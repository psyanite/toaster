import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Store } from '../models';
import StoreType from '../types/Store/StoreType';

export default {
  allStores: {
    type: new List(StoreType),
    resolve() {
      return Store.findAll({}).then(data => data);
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
};
