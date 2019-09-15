import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import AdminType from '../types/Admin/AdminType';
import Admin from '../models/Admin/Admin';
import bcrypt from 'bcrypt';

const SaltRounds = 10;

export default {
  addAdmin: {
    type: AdminType,
    args: {
      username: {
        type: new NonNull(String),
      },
      password: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { username, password }) => {
      const hash = await bcrypt.hash(password, SaltRounds);
      return Admin.create({ username, hash });
    }
  },
};
