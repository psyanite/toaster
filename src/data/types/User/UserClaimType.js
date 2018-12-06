import { GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserAccount, UserClaim } from '../../models';
import UserAccountType from './UserAccountType';

UserClaim.UserAccount = UserClaim.belongsTo(UserAccount, {
  foreignKey: 'user_id',
});

export default new ObjectType({
  name: 'UserClaim',
  user_account: {
    type: UserAccountType,
    resolve: resolver(UserClaim.UserAccount),
  },
  fields: () => ({
    type: { type: String },
    value: { type: String },
  }),
});
