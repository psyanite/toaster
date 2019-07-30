/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull } from 'graphql';
import { UserReward } from '../models';
import UserRewardType from '../types/User/UserRewardType';

export default {
  allUserRewards: {
    type: new List(UserRewardType),
    resolve() {
      return UserReward.findAll().then(data => data);
    },
  },

  allUserRewardsByUserId: {
    type: new List(UserRewardType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId }) => {
      return await UserReward.findAll({ where: { user_id: userId } })
    }
  },

  userRewardBy: {
    type: UserRewardType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      rewardId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, rewardId }) => {
      return await UserReward.findOne({ where: { user_id: userId, reward_id: rewardId } })
    }
  }
};
