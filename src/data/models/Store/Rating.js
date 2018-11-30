import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Rating = sequelize.define('store_ratings_cache', {
  store_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  heart_ratings: {
    type: Sequelize.INTEGER,
  },

  okay_ratings: {
    type: Sequelize.INTEGER,
  },

  burnt_ratings: {
    type: Sequelize.INTEGER,
  },
});

export default Rating;
