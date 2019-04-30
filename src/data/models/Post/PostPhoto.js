import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const PostPhoto = sequelize.define('post_photos', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  post_id: {
    type: Sequelize.INTEGER,
  },

  url: {
    type: Sequelize.TEXT,
  },
});

export default PostPhoto;
