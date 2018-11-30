import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';

import {
  Address,
  Cuisine,
  Location,
  Rating,
  Store,
  Suburb,
} from '../../models/index';
import SuburbType from '../Location/SuburbType';
import LocationType from '../Location/LocationType';
import AddressType from '../Location/AddressType';
import CuisineType from './CuisineType';
import RatingType from './RatingType';

Store.Location = Store.belongsTo(Location, { foreignKey: 'location_id' });
Store.Suburb = Store.belongsTo(Suburb, { foreignKey: 'suburb_id' });
Store.Address = Store.hasOne(Address);
Store.Cuisines = Store.belongsToMany(Cuisine, {
  through: 'store_cuisines',
  foreignKey: 'store_id',
});
Store.Rating = Store.hasOne(Rating, {
  through: 'store_ratings_cache',
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
    ratings: {
      type: RatingType,
      resolve: resolver(Store.Rating),
    },
  }),
});
