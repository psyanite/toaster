/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import Reward from '../models/Reward/Reward';
import RewardType from '../types/Reward/RewardType';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';

const Op = Sequelize.Op;

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
        type: new NonNull(String),
      },
    },
    resolve: async (_, { code }) => {
      return await Reward.findOne({ where: { code: code } })
    }
  },

  topRewards: {
    type: new List(RewardType),
    resolve: async () => {
      return await Reward.findAll({ where: { rank: 1 } });
    }
  },

  rewardsByStoreId: {
    type: new List(RewardType),
    args: {
      storeId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId }) => {
      const [results] = await sequelize
        .query(`
          select id from rewards r
          left join store_group_stores g on r.store_group_id = g.group_id
          where r.store_id = :storeId or g.store_id = :storeId;
          `, {
          replacements: { storeId: storeId }
        });
      if (!results || results.length === 0) {
        return null;
      }
      return await Reward.findAll({ where: {id: { [Op.in]: results.map(r => r.id) } } });
    }
  }
};
