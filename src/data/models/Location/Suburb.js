import DataType from 'sequelize'
import Model from '../../sequelize'

export default Model.define(
  'suburbs',
  {
    id: {
      type: DataType.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    name: {
      type: DataType.STRING(255),
    },

    city_id: {
      type: DataType.INTEGER,
    },
  },
  {
    indexes: [{ fields: ['name'] }],
  },
)
