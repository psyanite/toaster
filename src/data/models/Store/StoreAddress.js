import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const StoreAddress = sequelize.define('store_addresses', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  store_id: {
    type: Sequelize.INTEGER,
  },

  address_first_line: {
    type: Sequelize.TEXT,
  },

  address_second_line: {
    type: Sequelize.TEXT,
  },

  address_street_number: {
    type: Sequelize.TEXT,
  },

  address_street_name: {
    type: Sequelize.TEXT,
  },

  google_url: {
    type: Sequelize.TEXT,
  },
});

export default StoreAddress;
