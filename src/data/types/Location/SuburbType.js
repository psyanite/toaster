import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { City, Location, Suburb } from '../../models';
import LocationType from './LocationType';
import CityType from './CityType';
import { PointObject } from 'graphql-geojson';
import GeneralUtils from '../../../utils/GeneralUtils';

Suburb.City = Suburb.belongsTo(City, { constraints: false });
Suburb.Locations = Suburb.hasMany(Location, {
  as: 'locations',
  constraints: false,
});

export default new ObjectType({
  name: 'Suburb',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    city: {
      type: CityType,
      resolve: resolver(Suburb.City),
    },
    postcode: { type: Int },
    locations: {
      type: new List(LocationType),
      resolve: resolver(Suburb.Locations),
    },
    coords: {
      type: PointObject,
      resolve: GeneralUtils.resolveCoords,
    }
  }),
});
