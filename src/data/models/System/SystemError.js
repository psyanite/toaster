import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const SystemError = sequelize.define('system_errors', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  error_type: {
    type: Sequelize.STRING(64),
  },

  description: {
    type: Sequelize.STRING(255),
  },

  occurred_at: {
    type: Sequelize.DATE,
    defaultValue: Sequelize.NOW
  },
});

export default SystemError;
