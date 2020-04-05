import Sequelize from 'sequelize';
import configs from '../configs';

// https://github.com/sequelize/sequelize/issues/8417

const define = {
  underscored: true,
  underscoredAll: true,
  freezeTableName: true,
  timestamps: false,
};

const sequelize = new Sequelize(
  configs.database.name,
  configs.database.username,
  configs.database.password,
  {
    host: configs.database.host,
    port: configs.database.port,
    dialect: configs.database.dialect,
    logging: console.log,
    define,
  },
);

// import fs from 'fs';
// sequelize = new Sequelize(
//   configs.database.name,
//   configs.database.username,
//   configs.database.password,
//   {
//     host: configs.database.host,
//     port: configs.database.port,
//     dialect: configs.database.dialect,
//     logging: console.log,
//     define,
//     dialectOptions: {
//       ssl: {
//         mode: 'verify-ca',
//         rejectUnauthorized: false,
//         ca: fs.readFileSync('./secrets/knob-server-ca.pem').toString(),
//         key: fs.readFileSync('./secrets/knob-client-key.pem').toString(),
//         cert: fs.readFileSync('./secrets/knob-client-cert.pem').toString(),
//       },
//     }
//   }
// );


export default sequelize;
