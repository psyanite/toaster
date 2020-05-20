import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Post, UserAccount } from '../models';
import UserAccountType from '../types/User/UserAccountType';

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

  userAccountByEmail: {
    type: UserAccountType,
    args: {
      email: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { email }) => {
      return UserAccount.findOne({ where: { email } });
    }
  },
};
