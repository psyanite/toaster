import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const City = sequelize.define('cities', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(255),
  },

  district_id: {
    type: Sequelize.INTEGER,
  },
});

export default City;
