import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('posts', {
  id: {
    type: DataType.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  type: {
    type: DataType.ENUM('review', 'photo'),
  },

  store_id: {
    type: DataType.INTEGER,
  },

  posted_by_id: {
    type: DataType.INTEGER,
  },

  posted_at: {
    type: DataType.DATE,
  },
});
