import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const UserClaim = sequelize.define('user_claims', {
  user_account_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  type: {
    type: Sequelize.STRING,
  },

  value: {
    type: Sequelize.STRING,
  },
});

export default UserClaim;
