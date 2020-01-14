import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Admin = sequelize.define('admins', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  store_id: {
    type: Sequelize.NUMBER,
  },

  created_at: {
    type: Sequelize.DATE,
    allowNull: false,
    defaultValue: Sequelize.NOW
  },

  hash: {
    type: Sequelize.STRING(255),
  },
});

export default Admin;
