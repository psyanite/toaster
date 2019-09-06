/* eslint-disable no-param-reassign */
import { GraphQLFloat as Float, GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import Reward from '../models/Reward/Reward';
import RewardType from '../types/Reward/RewardType';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';
import StoreType from '../types/Store/StoreType';
import { Store } from '../models';

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
      const clean = query.replace(/\s+/g, ' | ');
      const [results] = await sequelize
        .query(`
          select id
          from reward_search
          where document @@ to_tsquery('english', :queryStr) or unaccent(lower(name)) like unaccent(lower(:likeStr))
          order by ts_rank(document, to_tsquery('english', :queryStr)) desc
        `, {
          replacements: { queryStr: clean, likeStr: `%${clean}%` }
        });
      if (!results || results.length === 0) {
        return [];
      }
      return Reward.findAll({ where: { id: { [Op.in]: results.map(r => r.id) } } });
    }
  },

  rewardsByCoords: {
    type: new List(StoreType),
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
      const attributes =  [[sequelize.literal(`mini(to_distance(coords, ${lat}, ${lng}))`), 'distance']];
      return Store.findAll({
        attributes: { include: attributes },
        include: [{ attributes: attributes }],
        order: sequelize.col('distance'),
        limit: limit,
        offset: offset,
      });
    }
  }
};
