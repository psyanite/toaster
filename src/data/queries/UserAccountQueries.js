/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Post, UserProfile, UserAccount } from '../models';
import UserAccountType from '../types/User/UserAccountType';
import UserProfileType from '../types/User/UserProfileType';

export default {

  allUserAccounts: {
    type: new List(UserAccountType),
    resolve() {
      return UserAccount.findAll().then(data => data);
    },
  },

  userAccountById: {
    type: UserAccountType,
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(UserAccount, {
      before: (findOptions, args) => {
        findOptions.where = { id: args.id, };
        findOptions.include = [{ model: Post, as: 'posts' }];
        findOptions.order = [[{ model: Post }, 'posted_at', 'DESC']];
        return findOptions;
      },
    }),
  },

  userProfileByUsername: {
    type: UserProfileType,
    args: {
      username: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { username }) => {
      return UserProfile.findOne({ where: { username: username } });
    }
  },
};
