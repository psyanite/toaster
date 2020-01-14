/* eslint-disable no-param-reassign */
import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { UserProfile } from '../models';
import UserProfileType from '../types/User/UserProfileType';

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
};
