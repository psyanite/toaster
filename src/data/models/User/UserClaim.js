import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('user_claims', {
  user_account_id: {
    type: DataType.INTEGER,
    primaryKey: true,
  },

  type: {
    type: DataType.STRING,
  },

  value: {
    type: DataType.STRING,
  },
});
