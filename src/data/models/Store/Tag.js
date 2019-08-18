import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const Tag = sequelize.define('tags', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  name: {
    type: Sequelize.STRING(100),
  },
});

export default Tag;
