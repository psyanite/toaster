import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Store = sequelize.define('stores', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(50),
  },

  phone_country: {
    type: Sequelize.STRING(20),
  },

  phone_number: {
    type: Sequelize.STRING(20),
  },

  location_id: {
    type: Sequelize.INTEGER,
  },

  suburb_id: {
    type: Sequelize.INTEGER,
  },

  city_id: {
    type: Sequelize.INTEGER,
  },

  cover_image: {
    type: Sequelize.TEXT,
  },

  order: {
    type: Sequelize.INTEGER,
  },

  rank: {
    type: Sequelize.INTEGER,
  },

  follower_count: {
    type: Sequelize.INTEGER,
  },

  review_count: {
    type: Sequelize.INTEGER,
  },

  z_id: {
    type: Sequelize.TEXT,
  },

  z_url: {
    type: Sequelize.TEXT,
  },

  more_info: {
    type: Sequelize.TEXT,
  },

  avg_cost: {
    type: Sequelize.INTEGER,
  },

  coords: {
    type: Sequelize.GEOMETRY('POINT'),
  }
});

export default Store;
