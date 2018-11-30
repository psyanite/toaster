import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const StoreGroup = sequelize.define('store_groups', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING,
  },
});

export default StoreGroup;
