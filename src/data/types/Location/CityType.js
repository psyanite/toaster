import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql'
import { resolver } from 'graphql-sequelize'
import { Suburb, City, District } from '../../models'
import SuburbType from './SuburbType'
import DistrictType from './DistrictType'

City.District = City.belongsTo(District, { constraints: false })
City.Suburbs = City.hasMany(Suburb, { as: 'suburbs', constraints: false })

export default new ObjectType({
  name: 'City',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    district: {
      type: DistrictType,
      resolve: resolver(City.District),
    },
    suburbs: {
      type: new List(SuburbType),
      resolve: resolver(City.Suburbs),
    },
  }),
})
