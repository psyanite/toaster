import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Suburb = sequelize.define('suburbs', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(255),
  },

  postcode: {
    type: Sequelize.INTEGER,
  },

  city_id: {
    type: Sequelize.INTEGER,
  },
});

export default Suburb;
