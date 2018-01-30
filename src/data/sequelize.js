import Sequelize from 'sequelize'
import config from '../../config/config'

// https://github.com/sequelize/sequelize/issues/8417

const sequelize = new Sequelize(
  config.database.name,
  config.database.username,
  config.database.password,
  {
    host: config.database.host,
    port: config.database.port,
    dialect: config.database.dialect,
    operatorsAliases: Sequelize.Op,
    define: {
      underscored: true,
      underscoredAll: true,
      freezeTableName: true,
      timestamps: false,
    },
  },
)

export default sequelize
