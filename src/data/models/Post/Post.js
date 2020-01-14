import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Post = sequelize.define('posts', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  type: {
    type: Sequelize.ENUM('review', 'photo'),
  },

  store_id: {
    type: Sequelize.INTEGER,
  },

  posted_by: {
    type: Sequelize.INTEGER,
  },

  like_count: {
    type: Sequelize.INTEGER,
  },

  comment_count: {
    type: Sequelize.INTEGER,
  },

  hidden: {
    type: Sequelize.BOOLEAN,
  },

  official: {
    type: Sequelize.BOOLEAN,
  },

  posted_at: {
    type: Sequelize.DATE,
    allowNull: false,
    defaultValue: Sequelize.NOW
  },
});

export default Post;
