import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Country = sequelize.define('countries', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(255),
  },
});

export default Country;
