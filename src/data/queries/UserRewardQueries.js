/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { UserReward } from '../models';
import UserRewardType from '../types/User/UserRewardType';

export default {
  allUserRewards: {
    type: new List(UserRewardType),
    resolve() {
      return UserReward.findAll().then(data => data);
    },
  },

  userRewardBy: {
    type: new List(UserRewardType),
    args: {
      userId: {
        type: Int,
      },
      rewardId: {
        type: Int,
      },
    },
    resolve: resolver(UserReward, {
      before: (findOptions, args) => {
        const where = {};
        if (args.userId) where.user_id = args.userId;
        if (args.rewardId) where.reward_id = args.rewardId;
        findOptions.where = where;
        return findOptions;
      },
    }),
  },
};
