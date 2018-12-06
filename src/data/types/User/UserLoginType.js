import { GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserAccount, UserLogin } from '../../models';
import UserAccountType from './UserAccountType';

UserLogin.UserAccount = UserLogin.belongsTo(UserAccount, {
  foreignKey: 'user_id',
});

export default new ObjectType({
  name: 'UserLogin',
  fields: () => ({
    user_account: {
      type: UserAccountType,
      resolve: resolver(UserLogin.UserAccount),
    },
    social_id: { type: String },
    social_type: { type: String },
  }),
});
