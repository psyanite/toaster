import express from 'express';
import graphqlHTTP from 'express-graphql';
import schema from './data/schema';
import configs from './configs';
import index from '../run/assets/index';

process.on('unhandledRejection', (reason, p) => {
  console.error('Unhandled Rejection at:', p, 'reason:', reason);
  process.exit(1);
});

const app = express();

app.use(
  '/graphql',
  (req, res) => {
    const auth = req.headers.authorization;
    if (req.method === 'POST' && req.headers.origin !== 'http://localhost:3000') {
      if (!auth) {
        throw new Error('Missing bearer token');
      } else if (auth !== `Bearer ${configs.api.bearer}`) {
        throw new Error('Invalid bearer token');
      }
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
);

app.use((err, req, res, _) => {
  res.status(403).send({ 'errors': [{ 'message': err.message }] });
});

app.get('*', (req, res, _) => {
  res.send(index);
});

if (!module.hot) {
  app.listen(configs.port, () => {
    console.info(`The server is running at http://localhost:${configs.port}/`);
  });
}

if (module.hot) {
  app.hot = module.hot;
}

export default app;
