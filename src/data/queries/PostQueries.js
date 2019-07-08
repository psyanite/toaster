/* eslint-disable no-param-reassign */
import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLBoolean as Boolean,
} from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Post, Store } from '../models';
import PostType from '../types/Post/PostType';
import sequelize from '../sequelize';

export default {
  allPosts: {
    type: new List(PostType),
    resolve() {
      return Post.findAll().then(data => data);
    },
  },

  postById: {
    type: new List(PostType),
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(Post),
  },

  postsByStoreId: {
    type: new List(PostType),
    args: {
      storeId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId }) => {
      return await sequelize
        .query(`
          SELECT DISTINCT ON (posted_by_id, store_id)
            *
          FROM posts
          WHERE store_id = :storeIdString
          AND hidden = FALSE
          ORDER BY posted_by_id, store_id, posted_at DESC
        `, {
          model: Post,
          replacements: { storeIdString: storeId }
        });
    },
  },

  // Find a way to prevent using the wrong API between public/storeAdmin/storeOwner/admin
  // adminPostsByStoreId: {
  //   type: new List(PostType),
  //   args: {
  //     storeId: {
  //       type: new NonNull(Int),
  //     },
  //     showHiddenPosts: {
  //       type: new NonNull(Boolean),
  //     },
  //   },
  //   resolve: resolver(Post, {
  //     before: (findOptions, args) => {
  //       if (args.showHiddenPosts) {
  //         findOptions.where = {
  //           store_id: args.storeId,
  //         };
  //       } else {
  //         findOptions.where = {
  //           store_id: args.storeId,
  //           hidden: false,
  //         };
  //       }
  //       findOptions.order = [['posted_at', 'DESC']];
  //       return findOptions;
  //     },
  //   }),
  // },

  postsByUserId: {
    type: new List(PostType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
      showHiddenPosts: {
        type: new NonNull(Boolean),
      },
    },
    resolve: resolver(Post, {
      before: (findOptions, args) => {
        if (args.showHiddenPosts) {
          findOptions.where = {
            posted_by_id: args.userId,
          };
        } else {
          findOptions.where = {
            posted_by_id: args.userId,
            hidden: false,
          };
        }
        findOptions.order = [['posted_at', 'DESC']];
        return findOptions;
      },
    }),
  },
};
