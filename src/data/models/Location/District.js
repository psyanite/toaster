import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define(
  'districts',
  {
    id: {
      type: DataType.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    name: {
      type: DataType.STRING(255),
    },

    country_id: {
      type: DataType.INTEGER,
    },
  },
  {
    indexes: [{ fields: ['name'] }],
  },
);
