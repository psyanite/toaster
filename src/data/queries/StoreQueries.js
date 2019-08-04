import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String, } from 'graphql';
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
          where document @@ to_tsquery('english', :queryString) or unaccent(lower(name)) like unaccent(lower(:likeString))
          order by ts_rank(document, to_tsquery('english', :queryString)) desc
        `, {
          model: Store,
          replacements: { queryString: clean, likeString: `%${clean}%` }
        });
    }
  },

  topStores: {
    type: new List(StoreType),
    resolve: async () => {
      return await Store.findAll({ where: { rank: 1 } });
    }
  }
};
