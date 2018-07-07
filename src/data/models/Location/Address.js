import DataType from 'sequelize';
import Model from '../../sequelize';

export default Model.define('store_addresses', {
  id: {
    type: DataType.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  store_id: {
    type: DataType.INTEGER,
  },

  address_first_line: {
    type: DataType.STRING(100),
  },

  address_second_line: {
    type: DataType.STRING(100),
  },

  address_street_number: {
    type: DataType.STRING(20),
  },

  address_street_name: {
    type: DataType.STRING(50),
  },

  google_url: {
    type: DataType.STRING(255),
  },
});
