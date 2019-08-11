import { GraphQLObjectType as ObjectType, GraphQLInt as Int, GraphQLNonNull as NonNull } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { UserFollow, UserProfile } from '../../models';
import UserProfileType from './UserProfileType';

// UserFollow.User = UserFollow.belongsTo(UserProfile, {
//   foreignKey: 'user_id',
// });

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
