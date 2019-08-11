import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import StoreType from '../types/Store/StoreType';
import UserAccount from '../models/User/UserAccount';
import StoreFollow from '../models/Store/StoreFollow';
import Store from '../models/Store/Store';
import StoreFollowType from '../types/Store/StoreFollowType';
import UserFollowType from '../types/User/UserFollowType';
import UserFollow from '../models/User/UserFollow';

export default {
  addStore: {
    type: StoreType,
    args: {
      name: {
        type: new NonNull(String),
      },
    },
    resolve: (value, { name }) => Store.create({ name }),
  },

  addStoreFollower: {
    type: StoreFollowType,
    args: {
      storeId: {
        type: new NonNull(Int),
      },
      followerId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, followerId }) => {
      const store = await Store.findByPk(storeId);
      if (store == null) throw Error(`Could not find Store by storeId: ${storeId}`);
      const follower = await UserAccount.findByPk(followerId);
      if (follower == null) throw Error(`Could not find UserAccount by followerId: ${followerId}`);
      const exist = await StoreFollow.findOne({ where: { store_id: storeId, follower_id: followerId } });
      if (exist != null) throw Error(`Follow already exists for storeId: ${storeId}, followerId: ${followerId}`);
      const follow = await StoreFollow.create({ store_id: storeId, follower_id: followerId });
      if (follow != null) await Store.decrement('follower_count', { where: { id: storeId }});
      return follow;
    }
  },

  deleteStoreFollower: {
    type: UserFollowType,
    args: {
      storeId: {
        type: new NonNull(Int),
      },
      followerId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, followerId }) => {
      const exist = await StoreFollow.findOne({ where: { store_id: storeId, follower_id: followerId } });
      if (exist == null) throw Error(`Follow already exists for storeId: ${storeId}, followerId: ${followerId}`);
      await exist.destroy();
      return exist;
    }
  },
};
