import {
  GraphQLBoolean as Boolean,
  GraphQLEnumType as EnumType,
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { GraphQLDate as Date } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Reward, Store, StoreGroup, UserProfile, UserReward } from '../../models';
import StoreType from '../Store/StoreType';
import StoreGroupType from '../Store/StoreGroupType';
import UserProfileType from '../User/UserProfileType';
import UserRewardType from '../User/UserRewardType';

Reward.Store = Reward.belongsTo(Store, { foreignKey: 'store_id' });
Reward.StoreGroup = Reward.belongsTo(StoreGroup, {
  foreignKey: 'store_group_id',
  as: 'storeGroup',
});
Reward.FavoritedBy = Reward.belongsToMany(UserProfile, {
  through: 'user_favorite_rewards',
  foreignKey: 'reward_id',
  otherKey: 'user_id',
  as: 'favoritedBy',
});
Reward.UserRewards = Reward.hasMany(UserReward, { as: 'userRewards' });

export const RewardTypeValues = Object.freeze({
  OneTime: 'one_time',
  Unlimited: 'unlimited',
  Loyalty: 'loyalty',
});

const RewardType = new EnumType({
  name: 'RewardType',
  values: {
    one_time: { value: 'one_time' },
    unlimited: { value: 'unlimited' },
    loyalty: { value: 'loyalty' },
  },
});

export default new ObjectType({
  name: 'Reward',
  fields: () => ({
    id: { type: new NonNull(Int) },
    code: { type: String },
    name: { type: String },
    description: { type: String },
    type: { type: RewardType },
    store: {
      type: StoreType,
      resolve: resolver(Reward.Store),
    },
    store_group: {
      type: StoreGroupType,
      resolve: resolver(Reward.StoreGroup),
    },
    valid_from: { type: Date },
    valid_until: { type: Date },
    promo_image: { type: String },
    terms_and_conditions: { type: String },
    active: { type: Boolean },
    hidden: { type: Boolean },
    redeem_limit: { type: Int },
    favorited_by: {
      type: List(UserProfileType),
      resolve: resolver(Reward.FavoritedBy),
    },
    user_rewards: {
      type: List(UserRewardType),
      resolve: resolver(Reward.UserRewards),
    },
  }),
});
