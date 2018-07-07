import {
  GraphQLInt as Int,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserAccount, UserClaim, UserLogin, UserProfile } from '../../models';
import UserProfileType from './UserProfileType';

UserAccount.UserClaim = UserAccount.hasMany(UserClaim, {
  foreignKey: 'user_account_id',
  as: 'claims',
});
UserAccount.UserLogin = UserAccount.hasMany(UserLogin, {
  foreignKey: 'user_account_id',
  as: 'logins',
});
UserAccount.UserProfile = UserAccount.hasOne(UserProfile, {
  foreignKey: 'user_account_id',
  as: 'profile',
});

export default new ObjectType({
  name: 'UserAccount',
  fields: () => ({
    id: { type: new NonNull(Int) },
    email: { type: String },
    profile: {
      type: UserProfileType,
      resolve: resolver(UserAccount.UserProfile),
    },
  }),
});
