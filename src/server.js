import express from 'express';
import graphqlHTTP from 'express-graphql';
import superagent from 'superagent';

import index from '../run/assets/index';
import configs from './configs';
import schema from './data/schema';
import CoffeeCat, { Emoji } from './utils/CoffeeCat';

function respondOk(res, msg) {
  res.status(200).send(msg)
}

function respondBad(res, status, msg) {
  res
    .status(status)
    .send({ 'errors': [{ 'message': msg }] });
}

function checkAuth(req) {
  const auth = req.headers.authorization;
  if (!auth || auth !== `Bearer ${configs.api.bearer}`) {
    throw new Error('meow');
  }
}

function runGraphqlQuery(req, res, query, callback) {
  checkAuth(req);

  const request = superagent
    .post(`${configs.url}/graphql`)
    .send({ query: `query { ${query} }` })
    .set('Authorization', `Bearer ${configs.api.bearer}`)
    .set('Content-type', 'application/json')
    .set('Accept', 'application/json');

  request
    .then((r) => {
      try {
        respondOk(res, callback(r));
      } catch (e) {
        console.log("Failed to perform GraphqlQuery");
        console.log(query);
        console.log(JSON.stringify(r));
        console.log(e);
        respondBad(res, 500, `Response: ${JSON.stringify(r)}, Error: ${e.message}`);
      }
    })
    .catch((e) => {
      CoffeeCat.msgAlert(Emoji.Error, 'GraphqlQuery', `Exception on query: ${query}, ${e.message}`)
      console.log("Failed to perform GraphqlQuery");
      console.log(query);
      console.log(e);
      respondBad(res, 500, e.message)
    });
}

function graphql(req, res) {
  if (req.method === 'POST') {
    checkAuth(req);
  }

  graphqlHTTP(req => ({
    schema,
    graphiql: true,
    rootValue: { request: req },
    pretty: true,
    customFormatErrorFn: error => ({
      message: error.message,
      locations: error.locations,
      stack: error.stack ? error.stack.split('\n') : [],
      path: error.path,
    }),
  }))(req, res)
}


process.on('unhandledRejection', (reason, p) => {
  console.error('Unhandled Rejection at:', p, 'reason:', reason);
  process.exit(1);
});


const app = express();


app.use('/graphql', graphql);


const cooperCallback = (r) => {
  const value = r.body.data.cooper.toString();
  const int = parseInt(value);
  const result = int > 498 ? 'Success' : 'Failed';
  return `${result} ${int}`;
}
app.get('/cmd/cooper', (req, res) => {
  runGraphqlQuery(req, res,'cooper', cooperCallback);
});

const bucketCallback = (r) => r.body.data.backupBuckets.toString();
app.get('/cmd/backupBuckets', (req, res) => {
  return runGraphqlQuery(req, res, 'backupBuckets', bucketCallback);
});

const cacheCallback = (r) => {
  const data = r.body.data;
  const result = (
    data['refreshMaterializedViews'] === 'Updated materialized views location_search, cuisine_search, store_search reward_search'
    && data['updatePostLikeCommentCache'].startsWith('Success')
    && data['updateRewardRankings'].startsWith('Success')
    && data['updateStoreRankings'].startsWith('Success')
    && data['updateStoreFollowerCount'].startsWith('Success')
    && data['updateUserFollowerCount'].startsWith('Success')
    && data['updateRewardCoords'].startsWith('Success')
  ) ? 'Success' : 'Failed';
  const msg = `${result}, Response: ${JSON.stringify(r.body.data)}`
  if (result === 'Success') {
    CoffeeCat.msgAlert(Emoji.Info, "RebuildCaches", "Done")
  } else {
    CoffeeCat.msgAlert(Emoji.Error, 'RebuildCaches', `Failed to rebuild caches\n${msg}`)
  }
  return msg;
}
app.get('/cmd/rebuildCaches', (req, res) => {
  CoffeeCat.msgAlert(Emoji.Info, "RebuildCaches", "Started")
  const query = `
    refreshMaterializedViews
    updatePostLikeCommentCache
    updateRewardRankings
    updateStoreRankings
    updateStoreFollowerCount
    updateUserFollowerCount
    updateRewardCoords
`;
  return runGraphqlQuery(req, res, query, cacheCallback);
});

app.use((err, req, res, _) => {
  res.status(403).send({ 'errors': [{ 'message': err.message }] });
});

app.get('*', (req, res, _) => {
  res.send(index);
});

if (!module.hot) {
  app.listen(configs.port, () => {
    console.info(`The server is running at ${configs.url}`);
  });
}

if (module.hot) {
  app.hot = module.hot;
}

export default app;
