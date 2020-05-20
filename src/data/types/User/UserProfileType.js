import { GraphQLInt as Int, GraphQLObjectType as ObjectType, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { Admin, UserAccount, UserProfile } from '../../models';
import UserAccountType from './UserAccountType';
import AdminType from '../Admin/AdminType';

UserProfile.UserAccount = UserProfile.belongsTo(UserAccount, { foreignKey: 'user_id' });
UserProfile.Admin = UserProfile.belongsTo(Admin, { foreignKey: 'admin_id' });

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
    first_name: { type: String },
    last_name: { type: String },
    tagline: { type: String },
    follower_count: { type: Int },
    store_count: { type: Int },
    fcm_token: { type: String },
    admin: {
      type: AdminType,
      resolve: resolver(UserProfile.Admin),
    },
  }),
});
