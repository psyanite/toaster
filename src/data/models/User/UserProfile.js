import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('user_profiles', {
  user_account_id: {
    type: DataType.INTEGER,
    primaryKey: true,
  },
  username: {
    type: DataType.STRING(64),
  },
  display_name: {
    type: DataType.STRING(64),
  },
  profile_picture: {
    type: DataType.TEXT,
  },
});
