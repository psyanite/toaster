import DataType from 'sequelize'
import Model from '../../sequelize'

export default Model.define(
  'user_accounts',
  {
    id: {
      type: DataType.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
  },
)
