import {
  GraphQLNonNull as NonNull,
  GraphQLString as String,
  GraphQLBoolean as Boolean,
  GraphQLInt as Int
} from 'graphql';
import { UserProfile } from '../models';
import UserProfileType from '../types/User/UserProfileType';
import sequelize from '../sequelize';

export default {

  userProfileByUsername: {
    type: UserProfileType,
    args: {
      username: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { username }) => {
      return UserProfile.findOne({ where: { username } });
    }
  },

  isValidUsername: {
    type: Boolean,
    args: {
      userId: {
        type: Int,
      },
      username: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { userId, username }) => {
      const query = userId == null ?
          `select sUsername
           from (
             select regexp_replace(username, '[^a-zA-Z0-9]+', '', 'g') as sUsername
             from user_profiles
           ) as t
           where sUsername = regexp_replace(:username, '[^a-zA-Z0-9]', '', 'g');`
        :
          `select sUsername
           from (
             select user_id,  regexp_replace(username, '[^a-zA-Z0-9]+', '', 'g') as sUsername
             from user_profiles
           ) as t
           where user_id != :userId and sUsername = regexp_replace(:username, '[^a-zA-Z0-9]', '', 'g');`;

        const [, result] = await sequelize
        .query(query, {
          replacements: { username: username, userId: userId }
        });

      return result.rowCount === 0;
    }
  }
};
