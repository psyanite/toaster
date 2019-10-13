import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const CommentLike = sequelize.define('comment_likes', {
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

  comment_id: {
    type: Sequelize.INTEGER,
  },
});

export default CommentLike;
