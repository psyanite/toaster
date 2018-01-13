/* eslint-disable no-param-reassign */
import {
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLInt as Int,
} from 'graphql'

import { resolver } from 'graphql-sequelize'
import { PostType } from '../types'
import { Post } from '../models'

export default {
  allPosts: {
    type: new List(PostType),
    resolve() {
      return Post.findAll({}).then(data => data)
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
    resolve: resolver(Post, {
      before: (findOptions, args) => {
        findOptions.where = {
          store_id: args.storeId,
        }
        findOptions.order = [['posted_at', 'ASC']]
        return findOptions
      },
    }),
  },

  postsByUserAccountId: {
    type: new List(PostType),
    args: {
      userAccountId: {
        type: new NonNull(Int),
      },
    },
    resolve: resolver(Post, {
      before: (findOptions, args) => {
        findOptions.where = {
          posted_by_id: args.userAccountId,
        }
        findOptions.order = [['posted_at', 'ASC']]
        return findOptions
      },
    }),
  },
}
