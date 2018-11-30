import {
  GraphQLEnumType as EnumType,
  GraphQLInt as Int,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { GraphQLDate as Date } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Reward, Store, StoreGroup } from '../../models';
import StoreType from '../Store/StoreType';
import StoreGroupType from '../Store/StoreGroupType';

Reward.Store = Reward.belongsTo(Store, { foreignKey: 'store_id' });
Reward.StoreGroup = Reward.belongsTo(StoreGroup, {
  foreignKey: 'store_group_id',
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
    expires_at: { type: Date },
    promo_image: { type: String },
  }),
});
