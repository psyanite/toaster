import DataType from 'sequelize'
import Model from '../../sequelize'

export default Model.define(
  'post_photos',
  {
    id: {
      type: DataType.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    post_id: {
      type: DataType.INTEGER,
    },

    photo: {
      type: DataType.TEXT,
    },
  },
)
