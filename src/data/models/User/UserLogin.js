import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const UserLogin = sequelize.define('user_logins', {
  social_type: {
    type: Sequelize.STRING(50),
    primaryKey: true,
  },

  social_id: {
    type: Sequelize.STRING(100),
    primaryKey: true,
  },

  user_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },
});

export default UserLogin;
