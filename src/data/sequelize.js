import Sequelize from 'sequelize';
import config from '../config';

// https://github.com/sequelize/sequelize/issues/8417

const define = {
  underscored: true,
  underscoredAll: true,
  freezeTableName: true,
  timestamps: false,
};

let sequelize;

if (config.env === config.ENV.development) {
  sequelize = new Sequelize(
    config.database.name,
    config.database.username,
    config.database.password,
    {
      host: config.database.host,
      port: config.database.port,
      dialect: config.database.dialect,
      operatorsAliases: Sequelize.Op,
      define,
    },
  );
} else {
  sequelize = new Sequelize(config.database.url, {
    operatorsAliases: Sequelize.Op,
    dialectOptions: {
      ssl: true,
    },
    define,
  });
}

export default sequelize;
