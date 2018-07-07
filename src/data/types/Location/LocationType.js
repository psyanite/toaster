import {
  GraphQLInt as Int,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Location, Suburb } from '../../models';
import SuburbType from './SuburbType';

Location.Suburb = Location.belongsTo(Suburb, { constraints: false });

export default new ObjectType({
  name: 'Location',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    suburb: {
      type: SuburbType,
      resolve: resolver(Location.Suburb),
    },
  }),
});
