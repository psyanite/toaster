import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('user_logins', {
  user_account_id: {
    type: DataType.INTEGER,
    primaryKey: true,
  },

  name: {
    type: DataType.STRING(50),
    primaryKey: true,
  },

  key: {
    type: DataType.STRING(100),
    primaryKey: true,
  },
});
