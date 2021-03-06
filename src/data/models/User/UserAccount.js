import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const UserAccount = sequelize.define('user_accounts', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  email: {
    type: Sequelize.STRING(255),
    validate: { isEmail: true },
  },
});

export default UserAccount;
