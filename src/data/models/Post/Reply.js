import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Reply = sequelize.define('comment_replies', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  comment_id: {
    type: Sequelize.INTEGER,
  },

  body: {
    type: Sequelize.STRING,
  },

  replied_by: {
    type: Sequelize.INTEGER,
  },

  replied_by_store: {
    type: Sequelize.INTEGER,
  },

  replied_at: {
    type: Sequelize.DATE,
    allowNull: false,
    defaultValue: Sequelize.NOW
  },

  reply_to: {
    type: Sequelize.INTEGER,
  }
});

export default Reply;
