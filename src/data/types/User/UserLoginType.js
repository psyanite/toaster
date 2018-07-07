import {
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserAccount, UserLogin } from '../../models';
import UserAccountType from './UserAccountType';

UserLogin.UserAccount = UserLogin.belongsTo(UserAccount, {
  foreignKey: 'user_account_id',
});

export default new ObjectType({
  name: 'UserLogin',
  fields: () => ({
    user_account: {
      type: UserAccountType,
      resolve: resolver(UserLogin.UserAccount),
    },
    name: { type: String },
    key: { type: String },
  }),
});
