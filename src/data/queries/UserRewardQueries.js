/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { Admin, StoreGroup, UserReward } from '../models';
import UserRewardType from '../types/User/UserRewardType';
import Sequelize from 'sequelize';
import Reward from '../models/Reward/Reward';
import RewardType, { RewardTypeValues } from '../types/Reward/RewardType';

const Op = Sequelize.Op;

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
      return UserReward.findAll({ where: { user_id: userId }});
    }
  },

  redeemedRewards: {
    type: new List(UserRewardType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId }) => {
      return UserReward.findAll({
        where: {
          user_id: userId,
          last_redeemed_at: { [Op.not]: null },
        },
        include: [{ model: Reward, where: { type: { [Op.ne]: RewardTypeValues.Loyalty }}}]
      });
    }
  },

  loyaltyRewardsByUserId: {
    type: new List(UserRewardType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId }) => {
      return UserReward.findAll({
        where: {
          user_id: userId,
          last_redeemed_at: { [Op.not]: null },
        },
        include: [{ model: Reward, where: { type: RewardTypeValues.Loyalty }}]
      });
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
      return UserReward.findOne({ where: { user_id: userId, reward_id: rewardId }});
    }
  },

  userRewardByCode: {
    type: UserRewardType,
    args: {
      code: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { code }) => {
      return UserReward.findOne({ where: { unique_code: code }});
    }
  },

  canHonorUserReward: {
    type: UserRewardType,
    args: {
      adminId: {
        type: new NonNull(Int),
      },
      code: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { adminId, code }) => {
      console.log(`canHonorUserReward: Requested for adminId: ${adminId}, code: ${code}`);

      const admin = await Admin.findByPk(adminId);
      if (admin == null) throw Error(`Could not find Admin by adminId: ${adminId}`);

      const exists = await UserReward.findOne({ where: { unique_code: code }});
      if (exists == null) throw Error(`Could not find UserReward by code: ${code}`);

      const reward = await Reward.findByPk(exists.reward_id ,{ include: [{ model: StoreGroup, as: 'storeGroup'}] });
      if (reward == null) throw Error(`Could not find Reward by rewardId: ${exists.reward_id}`);
      const rewardStoreId = reward.store_id;
      const storeIds = rewardStoreId != null ? [rewardStoreId] : await getStoreGroupStoreIds(reward);
      if (!storeIds.includes(admin.store_id)) throw Error(`Invalid adminId`);

      if (reward.type === RewardTypeValues.OneTime && exists.redeemed_count > 0) throw Error(`Already redeemed`);

      return exists;
    }
  }
};
