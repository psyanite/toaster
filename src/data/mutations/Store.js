import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import { Store } from '../models';
import StoreType from '../types/StoreType';

const addStore = {
  type: StoreType,
  description: 'Add a Store',
  args: {
    name: {
      name: 'Store name',
      type: new NonNull(String),
    },
  },
  resolve: (value, { name }) => Store.create({ name }),
};

const store = {
  addStore,
};

export default store;
