import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql'
import { resolver } from 'graphql-sequelize'
import { City, District, Country } from '../../models'
import CityType from './CityType'
import CountryType from './CountryType'

District.Country = District.belongsTo(Country, { constraints: false })
District.Cities = District.hasMany(City, { as: 'cities', constraints: false })

export default new ObjectType({
  name: 'District',
  fields: () => ({
    id: { type: new NonNull(Int) },
    name: { type: String },
    country: {
      type: CountryType,
      resolve: resolver(District.Country),
    },
    cities: {
      type: new List(CityType),
      resolve: resolver(District.Cities),
    },
  }),
})
