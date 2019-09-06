import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { PointObject } from 'graphql-geojson';

import { Address, Cuisine, Location, Rating, Store, Suburb, UserProfile, Tag, StoreHour, City } from '../../models';
import SuburbType from '../Location/SuburbType';
import LocationType from '../Location/LocationType';
import AddressType from '../Location/AddressType';
import CuisineType from './CuisineType';
import RatingType from './RatingType';
import UserProfileType from '../User/UserProfileType';
import TagType from './TagType';
import StoreHourType from './StoreHourType';
import CityType from '../Location/CityType';
import GeneralUtils from '../../../utils/GeneralUtils';

Store.Location = Store.belongsTo(Location, { foreignKey: 'location_id' });
Store.Suburb = Store.belongsTo(Suburb, { foreignKey: 'suburb_id' });
Store.City = Store.belongsTo(City, { foreignKey: 'city_id' });
Store.Address = Store.hasOne(Address);
Store.Cuisines = Store.belongsToMany(Cuisine, {
  through: 'store_cuisines',
  foreignKey: 'store_id',
});
Store.Hours = Store.hasMany(StoreHour, {
  foreignKey: 'store_id',
});
Store.Tags = Store.belongsToMany(Tag, {
  through: 'store_tags',
  foreignKey: 'store_id',
});
Store.Rating = Store.hasOne(Rating, {
  through: 'store_ratings_cache',
  foreignKey: 'store_id',
});
Store.FavoritedBy = Store.belongsToMany(UserProfile, {
  through: 'user_favorite_stores',
  foreignKey: 'store_id',
  otherKey: 'user_id',
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
    z_id: { type: String },
    z_url: { type: String },
    more_info: { type: String },
    avg_cost: { type: Int },
    coords: {
      type: PointObject,
      resolve: GeneralUtils.resolveCoords,
    },
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
    city: {
      type: CityType,
      resolve: resolver(Store.City),
    },
    hours: {
      type: new List(StoreHourType),
      resolve: resolver(Store.Hours),
    },
    cuisines: {
      type: new List(CuisineType),
      resolve: resolver(Store.Cuisines),
    },
    tags: {
      type: new List(TagType),
      resolve: resolver(Store.Tags),
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
