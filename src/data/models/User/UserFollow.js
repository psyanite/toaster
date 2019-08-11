import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const UserFollow = sequelize.define('user_follows', {
  user_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  follower_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },
});

export default UserFollow;
