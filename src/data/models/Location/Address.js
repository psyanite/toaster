import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Address = sequelize.define('store_addresses', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  store_id: {
    type: Sequelize.INTEGER,
  },

  address_first_line: {
    type: Sequelize.STRING(100),
  },

  address_second_line: {
    type: Sequelize.STRING(100),
  },

  address_street_number: {
    type: Sequelize.STRING(20),
  },

  address_street_name: {
    type: Sequelize.STRING(50),
  },

  google_url: {
    type: Sequelize.STRING(255),
  },
});

export default Address;
