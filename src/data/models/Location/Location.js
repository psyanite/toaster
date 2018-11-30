import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Location = sequelize.define('locations', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(255),
  },

  suburb_id: {
    type: Sequelize.INTEGER,
  },
});

export default Location;
