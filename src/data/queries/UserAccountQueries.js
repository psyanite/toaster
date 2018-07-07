import {
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLInt as Int,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { UserAccountType } from '../types';
import { UserAccount } from '../models';

export default {
  allUserAccounts: {
    type: new List(UserAccountType),
    resolve() {
      return UserAccount.findAll({}).then(data => data);
    },
  },

  userAccountById: {
    type: new List(UserAccountType),
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(UserAccount),
  },
};
