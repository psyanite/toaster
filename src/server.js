import express from 'express';
import graphqlHTTP from 'express-graphql';
import superagent from 'superagent';

import index from '../run/assets/index';
import configs, { Env } from './configs';
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

function checkAuth(req, res) {
  const auth = req.headers.authorization;
  if (!auth || auth !== `Bearer ${configs.api.bearer}`) {
    res.status(403).end();
  }
}

function cooper(req, res) {
  checkAuth(req, res);

  const request = superagent
    .post(`${configs.url}/graphql`)
    .send({ query: 'query { cooper }' })
    .set('Authorization', `Bearer ${configs.api.bearer}`)
    .set('Content-type', 'application/json')
    .set('Accept', 'application/json');

  request
    .then((r) => {
      try {
        respondOk(res, r.body.data.cooper.toString());
      } catch (e) {
        respondBad(res, 500, `Response: ${JSON.stringify(r)}, Error: ${e.message}`);
      }
    })
    .catch((e) => respondBad(res, 500, e.message));
}

function graphql(req, res) {
  if (req.method === 'POST') {
    checkAuth(req, res);
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

app.use('/graphql', (req, res) => graphql(req, res));

app.get('/cooper', (req, res) => cooper(req, res));

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

if (configs.env === Env.Prod) {
  CoffeeCat.msgAlert(Emoji.Success, '', 'Wormhole engaged')
}

export default app;
