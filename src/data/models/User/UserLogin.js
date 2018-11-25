import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('user_logins', {
  social_type: {
    type: DataType.STRING(50),
    primaryKey: true,
  },

  social_id: {
    type: DataType.STRING(100),
    primaryKey: true,
  },

  user_account_id: {
    type: DataType.INTEGER,
    primaryKey: true,
  },
});
