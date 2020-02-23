import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import * as Randomize from 'randomstring';
import { Reward, StoreGroup, UserAccount, UserReward } from '../models';
import UserRewardType from '../types/User/UserRewardType';
import { RewardTypeValues } from '../types/Reward/RewardType';
import Utils from '../../utils/Utils';

const createUserReward = async function (userId, rewardId) {
  let uniqueCode = Randomize.generate({ length: 4, capitalization: 'uppercase' });
  const uniqueCodeExists = await UserReward.findAll({ where: { unique_code: uniqueCode }}).then(data => data);
  if (uniqueCodeExists != null) uniqueCode = Randomize.generate({ length: 4, capitalization: 'uppercase' });
  return await UserReward.create({
    user_id: userId,
    reward_id: rewardId,
    unique_code: uniqueCode,
    redeemed_count: 0,
  });
};

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
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const reward = await Reward.findByPk(rewardId);
      if (reward == null) throw Error(`Could not find Reward by rewardId: ${rewardId}`);

      const exists = await UserReward.findOne({ where: { user_id: userId, reward_id: rewardId }});
      if (exists != null) throw Error(`UserReward already exists`);

      return createUserReward(userId, rewardId)
    }
  },

  honorReward: {
    type: UserRewardType,
    args: {
      code: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { code }) => {
      Utils.debug(`honorReward: Requested for code: ${code}`);

      const exists = await UserReward.findOne({ where: { unique_code: code }});
      if (exists == null) throw Error(`Could not find UserReward by code: ${code}`);

      const reward = await Reward.findByPk(exists.reward_id ,{ include: [{ model: StoreGroup, as: 'storeGroup'}] });
      if (reward == null) throw Error(`Could not find Reward by rewardId: ${exists.reward_id}`);

      switch (reward.type) {
        case RewardTypeValues.OneTime:
          if (exists.redeemed_count > 0) throw Error(`Reward has already been redeemed`);
          await exists.update({ redeemed_count: 1 });
          break;

        case RewardTypeValues.Unlimited:
          await exists.increment('redeemed_count');
          break;

        case RewardTypeValues.Loyalty:
          const redeemLimit = reward.redeem_limit;
          if (exists.redeemed_count < redeemLimit) await exists.increment('redeemed_count');
          else await exists.update({ redeemed_count: 0 });
          break;

        default:
          throw Error(`Invalid reward type`);
      }

      return exists.update({ last_redeemed_at: new Date() });
    }
  },
};
