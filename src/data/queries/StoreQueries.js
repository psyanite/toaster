import { GraphQLFloat as Float, GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Store } from '../models';
import StoreType from '../types/Store/StoreType';
import sequelize from '../../data/sequelize';
import GeneralUtils from '../../utils/GeneralUtils';

export default {
  topStores: {
    type: new List(StoreType),
    resolve: async () => {
      return Store.findAll({ where: { rank: 1 }, limit: 12 });
    }
  },

  storeById: {
    type: StoreType,
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(Store),
  },

  storeByZid: {
    type: StoreType,
    args: {
      zid: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { zid }) => {
      return Store.findOne({ where: { z_id: zid } });
    }
  },

  storesByQuery: {
    type: new List(StoreType),
    args: {
      query: {
        type: new NonNull(String),
      },
      limit: {
        type: new NonNull(Int),
      },
      offset: {
        type: new NonNull(Int),
      }
    },
    resolve: async (_, { query, limit, offset }) => {
      return await sequelize
        .query(`
          select *
          from store_search
          where document @@ to_tsquery('english', unaccent(lower(:queryStr))) or unaccent(lower(name)) like unaccent(lower(:likeStr))
          order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc
          limit :limitStr
          offset :offsetStr
        `, {
          model: Store,
          replacements: { queryStr: GeneralUtils.tsClean(query), likeStr: `%${query}%`, limitStr: limit, offsetStr: offset }
        });
    }
  },

  storesByQueryCoords: {
    type: new List(StoreType),
    args: {
      query: {
        type: new NonNull(String),
      },
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
    resolve: async (_, { query, lat, lng, limit, offset }) => {
      const tryA = await sequelize
        .query(`
          select *  
          from store_search
          where (document @@ to_tsquery('english', unaccent(lower(:queryStr))) or unaccent(lower(name)) like unaccent(lower(:likeStr)))
            and to_distance(coords, :lat, :lng) < 100
          order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc,
            to_distance(coords, :lat, :lng)
          limit :limitStr
          offset :offsetStr
        `, {
          model: Store,
          replacements: { queryStr: GeneralUtils.tsClean(query), likeStr: `%${query}%`, limitStr: limit, offsetStr: offset, lat, lng }
        });

      if (tryA.length > 0) return tryA;

      await sequelize
        .query(`
          select *  
          from store_search
          where (document @@ to_tsquery('english', unaccent(lower(:queryStr))) or unaccent(lower(name)) like unaccent(lower(:likeStr)))
          order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc,
            to_distance(coords, :lat, :lng)
          limit :limitStr
          offset :offsetStr
        `, {
          model: Store,
          replacements: { queryStr: GeneralUtils.tsClean(query), likeStr: `%${query}%`, limitStr: limit, offsetStr: offset, lat, lng }
        });
    }
  },

  storesByCoords: {
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
      return Store.findAll({
        attributes: { include: [[sequelize.literal(`to_distance(coords, ${lat}, ${lng})`), 'distance']] },
        order: sequelize.col('distance'),
        limit: limit,
        offset: offset,
      });
    }
  }
};
