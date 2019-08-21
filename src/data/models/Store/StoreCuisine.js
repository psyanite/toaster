import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const StoreCuisine = sequelize.define('store_cuisines', {
  store_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  cuisine_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },
});

export default StoreCuisine;
