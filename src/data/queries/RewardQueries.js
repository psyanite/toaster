/* eslint-disable no-param-reassign */
import { GraphQLFloat as Float, GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import Reward from '../models/Reward/Reward';
import RewardType from '../types/Reward/RewardType';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';
import StoreType from '../types/Store/StoreType';
import { UserProfile, UserReward } from '../models';

const Op = Sequelize.Op;

export default {

  allRewards: {
    type: new List(RewardType),
    args: {
      limit: {
        type: new NonNull(Int),
      },
      offset: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { limit, offset }) => {
      return Reward.findAll({
        where: { active: true, hidden: false },
        limit: limit,
        offset: offset,
      });
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
      return Reward.findOne({ where: { code: code } });
    }
  },

  topRewards: {
    type: new List(RewardType),
    resolve: async () => {
      return Reward.findAll({ where: { rank: 1 } });
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
          select id
          from rewards r
                 left join store_group_stores g on r.store_group_id = g.group_id
          where r.store_id = :storeId or g.store_id = :storeId;
        `, {
          replacements: { storeId: storeId }
        });
      if (!results || results.length === 0) {
        return [];
      }
      return Reward.findAll({ where: { id: { [Op.in]: results.map(r => r.id) } } });
    }
  },

  rewardsBySearch: {
    type: new List(StoreType),
    args: {
      query: {
        type: new NonNull(String),
      }
    },
    resolve: async (_, { query }) => {
      const [results] = await sequelize
        .query(`
          select id
          from reward_search
          where document @@ to_tsquery('english', :queryStr) or unaccent(lower(name)) like unaccent(lower(:likeStr))
          order by ts_rank(document, to_tsquery('english', :queryStr)) desc
        `, {
          replacements: { queryStr: GeneralUtils.tsClean(query), likeStr: `%${query}%` }
        });
      if (!results || results.length === 0) {
        return [];
      }
      return Reward.findAll({ where: { id: { [Op.in]: results.map(r => r.id) } } });
    }
  },

  rewardsByCoords: {
    type: new List(RewardType),
    args: {
      lat: {
        type: new NonNull(Float),
      },
      lng: {
        type: new NonNull(Float),
      },
      limit: {
        type: new NonNull(Int),
      },
      offset: {
        type: new NonNull(Int),
      }
    },
    resolve: async (_, { lat, lng, limit, offset }) => {
      return Reward.findAll({
        where: { hidden: false },
        attributes: { include: [[sequelize.literal(`mini(to_distance(coords, ${lat}, ${lng}))`), 'distance']] },
        order: sequelize.col('distance'),
        limit: limit,
        offset: offset,
      });
    }
  },

  rewardsByIds: {
    type: new List(RewardType),
    args: {
      ids: {
        type: new List(Int),
      },
    },
    resolve: async (_, { ids }) => {
      return Reward.findAll({ where: { id: { [Op.in]: ids } } });
    }
  },

  favoriteRewards: {
    type: new List(RewardType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId }) => {
      return Reward.findAll({
        include: [
          { model: UserReward, as: 'userRewards', where: { user_id: userId }, required: false },
          { model: UserProfile, as: 'favoritedBy', where: { user_id: userId } },
        ],
      order: [
        [ { model: UserReward, as: 'userRewards' }, 'last_redeemed_at', 'DESC NULLS LAST' ]
      ]
      });
    }
  },
};
