import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const District = sequelize.define('districts', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(255),
  },

  country_id: {
    type: Sequelize.INTEGER,
  },
});

export default District;
