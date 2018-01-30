import DataType from 'sequelize'
import Model from '../sequelize'

export default Model.define(
  'stores',
  {
    id: {
      type: DataType.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    name: {
      type: DataType.STRING(50),
    },

    phone_number: {
      type: DataType.STRING(20),
    },

    cover_image: {
      type: DataType.TEXT,
    },
  },
  {
    indexes: [{ fields: ['name'] }],
  },
)
