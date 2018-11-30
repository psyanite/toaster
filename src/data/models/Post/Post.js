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

  posted_by_id: {
    type: Sequelize.INTEGER,
  },

  posted_at: {
    type: Sequelize.DATE,
  },
});

export default Post;
