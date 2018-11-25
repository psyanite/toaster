import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('store_ratings_cache', {
  store_id: {
    type: DataType.INTEGER,
    primaryKey: true,
  },

  heart_ratings: {
    type: DataType.INTEGER,
  },

  okay_ratings: {
    type: DataType.INTEGER,
  },

  burnt_ratings: {
    type: DataType.INTEGER,
  },
});
