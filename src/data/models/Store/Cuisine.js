import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Cuisine = sequelize.define('cuisines', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(100),
  },
});

export default Cuisine;
