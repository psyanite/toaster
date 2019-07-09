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

  hidden: {
    type: Sequelize.BOOLEAN,
  },

  store_id: {
    type: Sequelize.INTEGER,
  },

  posted_by: {
    type: Sequelize.INTEGER,
  },

  posted_at: {
    type: Sequelize.DATE,
    allowNull: false,
    defaultValue: Sequelize.NOW
  },
});

export default Post;
