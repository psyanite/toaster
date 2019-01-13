/* eslint-disable no-param-reassign */
import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import UserProfileType from '../types/User/UserProfileType';
import { UserProfile, Store } from '../models';
import StoreType from '../types/Store/StoreType';

export default {
  profileByUserId: {
    type: new List(UserProfileType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(UserProfile, {
      before: (findOptions, args) => {
        findOptions.where = {
          user_id: args.userId,
        };
        return findOptions;
      },
    }),
  },
  favoriteStores: {
    type: new List(StoreType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId }) => {
      const userProfile = await FavoriteStore.findAll({ where: { user_id: userId }, include: [ Store ]});
      return userProfile;
    }
  },
};
