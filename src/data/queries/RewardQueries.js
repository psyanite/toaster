/* eslint-disable no-param-reassign */
import { GraphQLList as List, GraphQLString as String } from 'graphql';
import Reward from '../models/Reward/Reward';
import RewardType from '../types/Reward/RewardType';

export default {
  allRewards: {
    type: new List(RewardType),
    resolve: async () => {
      return await Reward.findAll({ where: { active: true, hidden: false } });
    }
  },
  rewardByCode: {
    type: RewardType,
    args: {
      code: {
        type: String,
      },
    },
    resolve: async (_, { code }) => {
      return await Reward.findOne({ where: { code: code } })
    }
  }
};
