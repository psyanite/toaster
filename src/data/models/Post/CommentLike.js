import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const CommentLike = sequelize.define('user_favorite_comments', {
  user_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  comment_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },
});

export default CommentLike;
