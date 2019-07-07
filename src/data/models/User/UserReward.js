import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const UserReward = sequelize.define('user_rewards', {
  user_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  reward_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  unique_code: {
    type: Sequelize.STRING,
  },

  redeemed_at: {
    type: Sequelize.DATE,
  },
});

export default UserReward;
