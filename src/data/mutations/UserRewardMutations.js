import { GraphQLInt as Int, GraphQLNonNull as NonNull } from 'graphql';
import * as Randomize from 'randomstring';

import { Reward, UserReward, UserAccount } from '../models';
import UserRewardType from '../types/User/UserRewardType';

export default {
  addUserReward: {
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
      const user = await UserAccount.findByPk(userId);
      if (user == null) throw Error(`Could not find UserAccount by userId: "${userId}"`);
      const reward = await Reward.findByPk(rewardId);
      if (reward == null) throw Error(`Could not find Reward by rewardId: "${rewardId}"`);
      let uniqueCode = Randomize.generate({ length: 4, capitalization: 'uppercase' });
      const exists = UserReward.findAll({ where: { unique_code: uniqueCode }}).then(data => data);
      if (exists != null) uniqueCode = Randomize.generate({ length: 4, capitalization: 'uppercase' });
      return UserReward.create({
        user_id: userId,
        reward_id: rewardId,
        unique_code: uniqueCode,
      }).then(data => data);
    }
  },
};
