import { GraphQLObjectType as ObjectType, GraphQLString as String, GraphQLInt as Int } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserAccount, UserProfile } from '../../models';
import UserAccountType from './UserAccountType';

UserProfile.UserAccount = UserProfile.belongsTo(UserAccount, {
  foreignKey: 'user_id',
});

export default new ObjectType({
  name: 'UserProfile',
  fields: () => ({
    user_id: { type: Int },
    user_account: {
      type: UserAccountType,
      resolve: resolver(UserProfile.UserAccount),
    },
    username: { type: String },
    preferred_name: { type: String },
    profile_picture: { type: String },
    gender: { type: String },
    firstname: { type: String },
    surname: { type: String },
    tagline: { type: String },
  }),
});
