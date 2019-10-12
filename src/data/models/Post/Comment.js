import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Comment = sequelize.define('comments', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  post_id: {
    type: Sequelize.INTEGER,
  },

  body: {
    type: Sequelize.STRING,
  },

  commented_by: {
    type: Sequelize.INTEGER,
  },

  commented_by_store: {
    type: Sequelize.INTEGER,
  },

  commented_at: {
    type: Sequelize.DATE,
    allowNull: false,
    defaultValue: Sequelize.NOW
  },
});

export default Comment;
