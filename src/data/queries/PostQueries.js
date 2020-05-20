import { GraphQLBoolean as Boolean, GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Post } from '../models';
import PostType from '../types/Post/PostType';
import sequelize from '../sequelize';

export default {
  postById: {
    type: PostType,
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
      limit: {
        type: new NonNull(Int),
      },
      offset: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, limit, offset }) => {
      return sequelize
        .query(`
          select * from (
            select distinct on (posted_by, store_id) *
            from posts
            where store_id = :storeId and official = false and hidden = false
            order by posted_by, store_id, posted_at desc
          ) a
          union (
            select * from posts
            where store_id = :storeId and official = true
          )
          order by posted_at desc
          limit :limitStr
          offset :offsetStr
        `, {
          model: Post,
          replacements: { storeId: storeId, limitStr: limit, offsetStr: offset},
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
      limit: {
        type: new NonNull(Int),
      },
      offset: {
        type: new NonNull(Int),
      },
      showHiddenPosts: {
        type: new NonNull(Boolean),
      },
    },
    resolve (_, { userId, limit, offset, showHiddenPosts }) {
      let where = { posted_by: userId };
      if (!showHiddenPosts) where.hidden = false;
      return Post.findAll({
        where: where,
        limit: limit,
        offset: offset,
        order: [['posted_at', 'DESC']]
      }).then(data => data);
    },
  },
};
