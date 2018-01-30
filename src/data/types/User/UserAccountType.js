import {
  GraphQLInt as Int,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
} from 'graphql'
import { resolver } from 'graphql-sequelize'

import { UserAccount, UserProfile } from '../../models'
import UserProfileType from './UserProfileType'

UserAccount.UserProfile = UserAccount.hasOne(UserProfile)

export default new ObjectType({
  name: 'UserAccount',
  fields: () => ({
    id: { type: new NonNull(Int) },
    profile: {
      type: UserProfileType,
      resolve: resolver(UserAccount.UserProfile),
    },
  }),
})
