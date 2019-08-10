import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const UserProfile = sequelize.define('user_profiles', {
  user_id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
  },

  username: {
    type: Sequelize.STRING(64),
  },

  preferred_name: {
    type: Sequelize.STRING(64),
  },

  profile_picture: {
    type: Sequelize.TEXT,
  },

  gender: {
    type: Sequelize.STRING(50),
  },

  firstname: {
    type: Sequelize.STRING(64),
  },

  surname: {
    type: Sequelize.STRING(64),
  },

  tagline: {
    type: Sequelize.STRING(64),
  },
});

export default UserProfile;
