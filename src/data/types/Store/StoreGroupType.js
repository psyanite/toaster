import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Store, StoreGroup } from '../../models';
import StoreType from './StoreType';

StoreGroup.Stores = StoreGroup.belongsToMany(Store, {
  through: 'store_group_stores',
  foreignKey: 'group_id',
  as: 'stores',
});

export default new ObjectType({
  name: 'StoreGroup',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    stores: {
      type: new List(StoreType),
      resolve: resolver(StoreGroup.Stores),
    },
  }),
});
