import { GraphQLObjectType as ObjectType, GraphQLInt as Int, GraphQLNonNull as NonNull } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { StoreFollow, UserProfile } from '../../models';
import UserProfileType from '../User/UserProfileType';

// StoreFollow.Store = UserFollow.belongsTo(Store, {
//   foreignKey: 'store_id',
// });

StoreFollow.Follower = StoreFollow.belongsTo(UserProfile, {
  foreignKey: 'follower_id',
});

export default new ObjectType({
  name: 'StoreFollow',
  fields: () => ({
    store_id: {
      type: new NonNull(Int),
    },
    follower: {
      type: UserProfileType,
      resolve: resolver(StoreFollow.Follower),
    },
  }),
});
