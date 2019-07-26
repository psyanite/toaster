import {
  GraphQLEnumType as EnumType,
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
  GraphQLBoolean as Boolean,
} from 'graphql';
import { GraphQLDate as Date } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Reward, Store, StoreGroup, UserAccount } from '../../models';
import StoreType from '../Store/StoreType';
import StoreGroupType from '../Store/StoreGroupType';
import UserAccountType from '../User/UserAccountType';

Reward.Store = Reward.belongsTo(Store, { foreignKey: 'store_id' });
Reward.StoreGroup = Reward.belongsTo(StoreGroup, {
  foreignKey: 'store_group_id',
});
Reward.FavoritedBy = Reward.belongsToMany(UserAccount, {
  through: 'user_favorite_stores',
  foreignKey: 'user_id',
  as: 'favoriteStores',
});

const RewardType = new EnumType({
  name: 'RewardType',
  values: {
    one_time: { value: 'one_time' },
  },
});

export default new ObjectType({
  name: 'Reward',
  fields: () => ({
    id: { type: new NonNull(Int) },
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
    active: { type: Boolean },
    hidden: { type: Boolean },
    redeem_limit: { type: Int },
    favorited_by: {
      type: List(UserAccountType),
      resolve: resolver(Reward.FavoritedBy),
    },
  }),
});
