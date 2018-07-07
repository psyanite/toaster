import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('post_reviews', {
  id: {
    type: DataType.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  overall_score: {
    type: DataType.ENUM('bad', 'okay', 'good'),
  },

  taste_score: {
    type: DataType.ENUM('bad', 'okay', 'good'),
  },

  service_score: {
    type: DataType.ENUM('bad', 'okay', 'good'),
  },

  value_score: {
    type: DataType.ENUM('bad', 'okay', 'good'),
  },

  ambience_score: {
    type: DataType.ENUM('bad', 'okay', 'good'),
  },

  body: {
    type: DataType.TEXT,
  },
});
