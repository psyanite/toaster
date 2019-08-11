/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';
import UserProfileType from '../types/User/UserProfileType';
import { Store, UserProfile } from '../models';
import StoreType from '../types/Store/StoreType';
import * as Randomize from 'randomstring';
import sequelize from '../sequelize';

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
      return await FavoriteStore.findAll({ where: { user_id: userId }, include: [Store] });
    }
  },

  followedUsers: {
    type: new List(Int),
    args: {
      userId: {
        type: new NonNull(Int),
      }
    },
    resolve: async (_, { userId }) => {
      const [results] = await sequelize
        .query(`
          select user_id from user_follows where follower_id = :userId;
        `, { replacements: { userId: userId } });
      if (results == null) {
        return [];
      }
      return  results.map(r => r.user_id);
    }
  },

  followedStores: {
    type: new List(Int),
    args: {
      userId: {
        type: new NonNull(Int),
      }
    },
    resolve: async (_, { userId }) => {
      const [results] = await sequelize
        .query(`
          select store_id from store_follows where follower_id = :userId;
        `, { replacements: { userId: userId } });
      if (results == null) {
        return [];
      }
      return  results.map(r => r.store_id);
    }
  },

  meow: {
    type: String,
    resolve: async () => {
      let uniqueCode = Randomize.generate({ length: 5, charset: 'bcdfghjklmnpqrtvwxBCDFGHJKLMNPQRTVWX23456789' });
      return uniqueCode.toString();
    }
  }
};
