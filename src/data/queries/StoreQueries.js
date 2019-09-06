import { GraphQLFloat as Float, GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Store } from '../models';
import StoreType from '../types/Store/StoreType';
import sequelize from '../../data/sequelize';

export default {
  allStores: {
    type: new List(StoreType),
    resolve() {
      return Store.findAll({ order: [['order', 'ASC']] }).then(data => data);
    },
  },

  storeById: {
    type: new List(StoreType),
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(Store),
  },

  storesBySearch: {
    type: new List(StoreType),
    args: {
      query: {
        type: new NonNull(String),
      }
    },
    resolve: async (_, { query }) => {
      const clean = query.replace(/\s+/g, ' | ');
      return await sequelize
        .query(`
          select *
          from store_search
          where document @@ to_tsquery('english', :queryStr) or unaccent(lower(name)) like unaccent(lower(:likeStr))
          order by ts_rank(document, to_tsquery('english', :queryStr)) desc
        `, {
          model: Store,
          replacements: { queryStr: clean, likeStr: `%${clean}%` }
        });
    }
  },

  topStores: {
    type: new List(StoreType),
    resolve: async () => {
      return Store.findAll({ where: { rank: 1 } });
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
