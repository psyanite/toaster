const ENV = {
  development: 'development',
  stage: 'stage',
  production: 'production',
};

if (process.env.NODE_ENV !== ENV.production) {
  require('dotenv').config();
}

const env = process.env.NODE_ENV || ENV.development;

module.exports = {
  ENV,

  env: env,

  port: process.env.PORT || 3000,

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
  }
};
