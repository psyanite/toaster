import { GraphQLFloat as Float, GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Store } from '../models';
import StoreType from '../types/Store/StoreType';
import sequelize from '../../data/sequelize';
import Utils from '../../utils/Utils';
import Sequelize from 'sequelize';

const Op = Sequelize.Op;

export default {
  topStores: {
    type: new List(StoreType),
    resolve: async () => {
      return Store.findAll({
        where: { rank: 1 },
        limit: 12,
        order: sequelize.random(),
      });
    }
  },

  famousStores: {
    type: new List(StoreType),
    resolve: async () => {
      const famousStoreIds = [63788, 63793, 63856, 63830, 63831, 63797];
      return Store.findAll({
        where: { id: { [Op.in]: famousStoreIds } },
        order: sequelize.random(),
      });
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
      return sequelize
        .query(`
          select *
          from store_search
          where document @@ to_tsquery('english', unaccent(lower(:queryStr))) or unaccent(name) ~* unaccent(:queryStr)
          order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc
          limit :limitStr offset :offsetStr
        `, {
          model: Store,
          replacements: { queryStr: Utils.tsClean(query), limitStr: limit, offsetStr: offset }
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
          where (document @@ to_tsquery('english', unaccent(lower(:queryStr))) or unaccent(name) ~* unaccent(:queryStr)) and
            (coords <@> point(:lng, :lat)) * 1.60934 < 100
          order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc,
            (coords <@> point(:lng, :lat)) * 1.60934
          limit :limitStr offset :offsetStr
        `, {
          model: Store,
          replacements: { queryStr: Utils.tsClean(query), limitStr: limit, offsetStr: offset, lat, lng }
        });

      if (tryA.length > 0) return tryA;

      return sequelize
        .query(`
          select *
          from store_search
          where document @@ to_tsquery('english', unaccent(lower(:queryStr))) or unaccent(name) ~* unaccent(:queryStr)
          order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc,
            (coords <@> point(:lng, :lat)) * 1.60934
          limit :limitStr offset :offsetStr
        `, {
          model: Store,
          replacements: { queryStr: Utils.tsClean(query), limitStr: limit, offsetStr: offset, lat, lng }
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
        attributes: { include: [[sequelize.literal(`(coords <@> point(${lng}, ${lat})) * 1.60934`), 'distance']] },
        order: sequelize.col('distance'),
        limit: limit,
        offset: offset,
      });
    }
  },

  storesByCuisines: {
    type: new List(StoreType),
    args: {
      cuisines: {
        type: new List(Int),
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
    resolve: async (_, { cuisines, lat, lng, limit, offset }) => {
      return sequelize
        .query(`
          select stores.*,
            (coords <@> point(:lng, :lat)) * 1.60934 as distance
          from stores
                 join store_cuisines sc on stores.id = sc.store_id and sc.cuisine_id in (:cuisines)
          group by stores.id
          order by distance
          limit :limitStr offset :offsetStr;
        `, {
          model: Store,
          replacements: { cuisines, lat, lng, limitStr: limit, offsetStr: offset }
        });
    }
  },
};

