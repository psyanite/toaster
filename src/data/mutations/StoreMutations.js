import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import { Store } from '../models';
import StoreType from '../types/Store/StoreType';

const addStore = {
  type: StoreType,
  description: 'Add a Store',
  args: {
    name: {
      type: new NonNull(String),
    },
  },
  resolve: (value, { name }) => Store.create({ name }),
};

export default {
  addStore,
};
