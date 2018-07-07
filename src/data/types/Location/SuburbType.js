import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Location, Suburb, City } from '../../models';
import LocationType from './LocationType';
import CityType from './CityType';

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
    locations: {
      type: new List(LocationType),
      resolve: resolver(Suburb.Locations),
    },
  }),
});
