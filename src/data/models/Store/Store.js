import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Store = sequelize.define('stores', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(50),
  },

  phone_number: {
    type: Sequelize.STRING(20),
  },

  cover_image: {
    type: Sequelize.TEXT,
  },
});

export default Store;
