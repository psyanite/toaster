import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import { Store } from '../models';
import StoreType from '../types/Store/StoreType';

export default {
  addStore: {
    type: StoreType,
    args: {
      name: {
        type: new NonNull(String),
      },
    },
    resolve: (value, { name }) => Store.create({ name }),
  },
};
