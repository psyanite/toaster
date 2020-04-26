export const Env = {
  Dev: 'development',
  Stage: 'stage',
  Prod: 'production',
};

if (process.env.NODE_ENV !== Env.Prod) {
  require('dotenv').config();
}

const env = process.env.NODE_ENV || Env.Dev;

let envCode;
switch (env) {
  case Env.Dev: envCode = 'DEV'; break;
  case Env.Stage: envCode = 'STAGE'; break;
  case Env.Prod: envCode = 'PROD'; break;
  case _: envCode = "DEV";
}

const port = process.env.PORT || 3000;
const url = env === Env.Prod ? 'https://burntoast.appspot.com' : `http://localhost:${port}`;

export default {

  env: env,
  envCode: envCode,

  url: url,
  port: port,

  api: {
    bearer: process.env.BEARER || '',
  },

  database: {
    name: process.env.DATABASE_NAME || 'public',
    dialect: process.env.DATABASE_DIALECT || 'postgres',
    host: process.env.DATABASE_HOST || 'localhost',
    port: process.env.DATABASE_PORT || 5432,
    username: process.env.DATABASE_USERNAME || 'username',
    password: process.env.DATABASE_PASSWORD || 'password',
  },

  coffeeCat: {
    alertHook: process.env.COFFEE_CAT_ALERT_HOOK || '',
  }
};
