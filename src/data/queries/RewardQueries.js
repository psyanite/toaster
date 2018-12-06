/* eslint-disable no-param-reassign */
import { GraphQLList as List } from 'graphql';
import Reward from '../models/Reward/Reward';
import RewardType from '../types/Reward/RewardType';

export default {
  allRewards: {
    type: new List(RewardType),
    resolve() {
      return Reward.findAll().then(data => data);
    },
  },
};
