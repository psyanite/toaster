import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql'
import { resolver } from 'graphql-sequelize'
import { Country, District } from '../../models'
import DistrictType from './DistrictType'

Country.Districts = Country.hasMany(District, {
  as: 'districts',
  constraint: false,
})

export default new ObjectType({
  name: 'Country',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    districts: {
      type: new List(DistrictType),
      resolve: resolver(Country.Districts),
    },
  }),
  underscored: true,
});
