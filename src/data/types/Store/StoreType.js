import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';

import { Address, Cuisine, Location, Rating, Store, Suburb, UserProfile } from '../../models/index';
import SuburbType from '../Location/SuburbType';
import LocationType from '../Location/LocationType';
import AddressType from '../Location/AddressType';
import CuisineType from './CuisineType';
import RatingType from './RatingType';
import UserProfileType from '../User/UserProfileType';

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
Store.FavoritedBy = Store.belongsToMany(UserProfile, {
  through: 'user_favorite_stores',
  foreignKey: 'store_id',
  as: 'favoritedBy',
});

export default new ObjectType({
  name: 'Store',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    phone_number: { type: String },
    cover_image: { type: String },
    order: { type: Int },
    rank: { type: Int },
    follower_count: { type: Int },
    review_count: { type: Int },
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
    favorited_by: {
      type: List(UserProfileType),
      resolve: resolver(Store.FavoritedBy),
    },
  }),
});
