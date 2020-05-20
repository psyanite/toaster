import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserFollow, UserProfile } from '../../models';
import UserProfileType from './UserProfileType';

UserFollow.Follower = UserFollow.belongsTo(UserProfile, {
  foreignKey: 'follower_id',
});

export default new ObjectType({
  name: 'UserFollow',
  fields: () => ({
    user_id: {
      type: new NonNull(Int),
    },
    follower: {
      type: UserProfileType,
      resolve: resolver(UserFollow.Follower),
    },
  }),
});
