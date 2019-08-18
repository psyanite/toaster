import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Store, Tag } from '../../models';
import StoreType from './StoreType';

Tag.Stores = Tag.belongsToMany(Store, {
  through: 'store_tags',
  foreignKey: 'tag_id',
});

export default new ObjectType({
  name: 'Tag',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    stores: {
      type: new List(StoreType),
      resolve: resolver(Tag.Stores),
    },
  }),
});
