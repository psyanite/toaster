import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserAccount, UserClaim, UserLogin, UserProfile } from '../../models';
import UserProfileType from './UserProfileType';
import Post from '../../models/Post/Post';
import PostType from '../Post/PostType';

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
UserAccount.Posts = UserAccount.hasMany(Post, {
  foreignKey: 'posted_by_id',
  as: 'posts',
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
    posts: {
      type: new List(PostType),
      resolve: resolver(UserAccount.Posts),
    },
  }),
});
