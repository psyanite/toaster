import {
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLInt as Int,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { StoreType } from '../types';
import { Store } from '../models';

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
