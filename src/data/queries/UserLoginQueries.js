/* eslint-disable no-param-reassign */
import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { UserLogin } from '../models';
import UserLoginType from '../types/User/UserLoginType';

export default {
  userLogin: {
    type: UserLoginType,
    args: {
      socialType: {
        type: new NonNull(String),
      },
      socialId: {
        type: new NonNull(String),
      },
    },
    resolve: resolver(UserLogin, {
      before: (findOptions, args) => {
        findOptions.where = {
          social_type: args.socialType,
          social_id: args.socialId,
        };
        return findOptions;
      },
    }),
  },
};
