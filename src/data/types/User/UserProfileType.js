import { GraphQLObjectType as ObjectType, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserAccount, UserProfile } from '../../models';
import UserAccountType from './UserAccountType';

UserProfile.UserAccount = UserProfile.belongsTo(UserAccount, {
  foreignKey: 'user_id',
});

export default new ObjectType({
  name: 'UserProfile',
  fields: () => ({
    user_account: {
      type: UserAccountType,
      resolve: resolver(UserProfile.UserAccount),
    },
    username: { type: String },
    display_name: { type: String },
    profile_picture: { type: String },
    gender: { type: String },
  }),
});
