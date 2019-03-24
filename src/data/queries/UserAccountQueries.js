/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { UserAccount } from '../models';
import UserAccountType from '../types/User/UserAccountType';
import Post from '../models/Post/Post';

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

  userAccountByUsername: {
    type: UserAccountType,
    args: {
      username: {
        type: new NonNull(String),
      },
    },
    resolve: resolver(UserAccount, {
      before: (findOptions, args) => {
        findOptions.where = {
          username: args.username,
        };
        return findOptions;
      },
    }),
  },
};
