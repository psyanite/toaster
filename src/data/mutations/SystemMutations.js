import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import { SystemError } from '../models';
import SystemErrorType from '../types/System/SystemErrorType';

export default {
  addSystemError: {
    type: SystemErrorType,
    args: {
      errorType: {
        type: new NonNull(String),
      },
      description: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { errorType, description }) => {
      return SystemError.create({ error_type: errorType, description: description.slice(0,250) });
    }
  },
};
