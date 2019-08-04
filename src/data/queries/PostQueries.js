/* eslint-disable no-param-reassign */
import { GraphQLBoolean as Boolean, GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Post } from '../models';
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

  allPostsByStoreId: {
    type: new List(PostType),
    args: {
      storeId: {
        type: new NonNull(Int),
      },
    },
    resolve (_, { storeId }) {
      return Post.findAll({ where: { store_id: storeId }}).then(data => data);
    }
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
          select * from (
            select distinct on (posted_by, store_id) *
            from posts
            where store_id = :storeId and posted_by is not null and hidden = false
            order by posted_by, store_id, posted_at desc
          ) a
          union (
            select * from posts
            where store_id = :storeId and posted_by is null
          )
          order by posted_at desc;
        `, {
          model: Post,
          replacements: { storeId: storeId },
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
            posted_by: args.userId,
          };
        } else {
          findOptions.where = {
            posted_by: args.userId,
            hidden: false,
          };
        }
        findOptions.order = [['posted_at', 'DESC']];
        return findOptions;
      },
    }),
  },
};
