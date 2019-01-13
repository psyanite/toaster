import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Store } from '../models';
import StoreType from '../types/Store/StoreType';
import sequelize from '../../data/sequelize';

export default {
  allStores: {
    type: new List(StoreType),
    resolve() {
      return Store.findAll().then(data => data);
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
      return await sequelize
        .query(`
          SELECT *
          FROM store_search
          WHERE document @@ to_tsquery('english', :queryString)
          ORDER BY ts_rank(document, to_tsquery('english', :queryString)) DESC
        `, {
          model: Store,
          replacements: { queryString: query.replace(/\s+/g, ' | ') }
        });
    }
  }
};
