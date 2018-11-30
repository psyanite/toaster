import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Reward = sequelize.define('rewards', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING,
  },

  description: {
    type: Sequelize.STRING,
  },

  type: {
    type: Sequelize.ENUM('one_time'),
  },

  store_id: {
    type: Sequelize.INTEGER,
  },

  store_group_id: {
    type: Sequelize.INTEGER,
  },

  valid_from: {
    type: Sequelize.DATEONLY,
  },

  expires_at: {
    type: Sequelize.DATE,
  },

  promo_image: {
    type: Sequelize.STRING,
  },
});

export default Reward;
