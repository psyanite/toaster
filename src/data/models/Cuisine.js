import DataType from 'sequelize'
import Model from '../sequelize'

export default Model.define(
  'cuisines',
  {
    id: {
      type: DataType.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    name: {
      type: DataType.STRING(100),
    },
  },
)
