/* eslint-disable no-param-reassign */
import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import UserProfileType from '../types/User/UserProfileType';
import { UserProfile } from '../models';

export default {
  profileByUserAccountId: {
    type: new List(UserProfileType),
    args: {
      userAccountId: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(UserProfile, {
      before: (findOptions, args) => {
        findOptions.where = {
          user_account_id: args.userAccountId,
        };
        return findOptions;
      },
    }),
  },
};
