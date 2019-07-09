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
import Store from '../../models/Store/Store';
import RewardType from '../Reward/RewardType';
import StoreType from '../Store/StoreType';
import Reward from '../../models/Reward/Reward';

UserAccount.UserClaim = UserAccount.hasMany(UserClaim, {
  foreignKey: 'user_id',
  as: 'claims',
});
UserAccount.UserLogin = UserAccount.hasMany(UserLogin, {
  foreignKey: 'user_id',
  as: 'logins',
});
UserAccount.UserProfile = UserAccount.hasOne(UserProfile, {
  foreignKey: 'user_id',
  as: 'profile',
});
UserAccount.Posts = UserAccount.hasMany(Post, {
  foreignKey: 'posted_by',
  as: 'posts',
});
UserAccount.FavoriteRewards = UserAccount.belongsToMany(Reward, {
  through: 'user_favorite_rewards',
  foreignKey: 'user_id',
  as: 'favoriteRewards',
});
UserAccount.FavoriteStores = UserAccount.belongsToMany(Store, {
  through: 'user_favorite_stores',
  foreignKey: 'user_id',
  as: 'favoriteStores',
});
UserAccount.FavoritePosts = UserAccount.belongsToMany(Post, {
  through: 'user_favorite_posts',
  foreignKey: 'user_id',
  as: 'favoritePosts',
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
    favorite_rewards: {
      type: List(RewardType),
      resolve: resolver(UserAccount.FavoriteRewards),
    },
    favorite_stores: {
      type: List(StoreType),
      resolve: resolver(UserAccount.FavoriteStores),
    },
    favorite_posts: {
      type: List(PostType),
      resolve: resolver(UserAccount.FavoritePosts),
    },
  }),
});
