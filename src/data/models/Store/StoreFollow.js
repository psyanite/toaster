import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const StoreFollow = sequelize.define('store_follows', {
  store_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  follower_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },
});

export default StoreFollow;
