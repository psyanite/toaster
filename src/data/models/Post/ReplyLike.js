import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const ReplyLike = sequelize.define('user_favorite_replies', {
  user_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  reply_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },
});

export default ReplyLike;
