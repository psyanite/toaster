import { GraphQLObjectType as ObjectType } from 'graphql'
import StoreQueries from './StoreQueries'
import UserAccountQueries from './UserAccountQueries'
import PostQueries from './PostQueries'

export default new ObjectType({
  name: 'Meowry',
  fields: Object.assign(
    {},
    StoreQueries,
    UserAccountQueries,
    PostQueries,
  ),
})
