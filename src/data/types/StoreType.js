import {
  GraphQLInt as Int,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
  GraphQLList as List,
} from 'graphql';
import { resolver } from 'graphql-sequelize';

import { Store, Location, Suburb, Cuisine, Address } from '../models';
import SuburbType from './Location/SuburbType';
import LocationType from './Location/LocationType';
import AddressType from './Location/AddressType';
import CuisineType from './CuisineType';

Store.Location = Store.belongsTo(Location, { foreignKey: 'location_id' });
Store.Suburb = Store.belongsTo(Suburb, { foreignKey: 'suburb_id' });
Store.Address = Store.hasOne(Address);
Store.Cuisines = Store.belongsToMany(Cuisine, {
  through: 'store_cuisines',
  foreignKey: 'store_id',
});

export default new ObjectType({
  name: 'Store',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    phone_number: { type: String },
    cover_image: { type: String },
    address: {
      type: AddressType,
      resolve: resolver(Store.Address),
    },
    location: {
      type: LocationType,
      resolve: resolver(Store.Location),
    },
    suburb: {
      type: SuburbType,
      resolve: resolver(Store.Suburb),
    },
    cuisines: {
      type: new List(CuisineType),
      resolve: resolver(Store.Cuisines),
    },
  }),
});
