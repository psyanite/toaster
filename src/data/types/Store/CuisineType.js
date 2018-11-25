import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Cuisine, Store } from '../../models/index';
import StoreType from './StoreType';

Cuisine.Stores = Cuisine.belongsToMany(Store, {
  through: 'store_cuisines',
  foreignKey: 'cuisine_id',
});

export default new ObjectType({
  name: 'Cuisine',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    stores: {
      type: new List(StoreType),
      resolve: resolver(Cuisine.Stores),
    },
  }),
});
