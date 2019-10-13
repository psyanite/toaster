import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const ReplyLike = sequelize.define('comment_reply_likes', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  user_id: {
    type: Sequelize.INTEGER,
  },

  store_id: {
    type: Sequelize.INTEGER,
  },

  reply_id: {
    type: Sequelize.INTEGER,
  },
});

export default ReplyLike;
