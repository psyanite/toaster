import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const StoreHour = sequelize.define('store_hours', {
  store_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  order: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  dotw: {
    type: Sequelize.TEXT,
  },

  hours: {
    type: Sequelize.TEXT,
  },
});

export default StoreHour;
