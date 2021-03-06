import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull } from 'graphql';
import PostType from '../types/Post/PostType';
import FeedService, { Feed } from '../services/FeedService';
import { Post } from '../models';
import Sequelize from 'sequelize';

const Op = Sequelize.Op;

const UserFeeds = new Map();
let DefaultFeed = new Feed([]);

const isExpired = (createdAt) => {
  return createdAt < new Date(new Date() - 10*60000)
};

const slice = (feed, limit, offset) => {
  return Array.from(feed).slice(offset).slice(0, limit);
};

export default {
  feedByDefault: {
    type: new List(PostType),
    args: {
      limit: {
        type: new NonNull(Int),
      },
      offset: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { limit, offset }) => {
      if (!DefaultFeed.postIds.length || isExpired(DefaultFeed.createdAt)) {
        DefaultFeed = await FeedService.getGenericFeed();
      }
      const ids = slice(DefaultFeed.postIds, limit, offset);
      return Post.findAll({
        where: { id: { [Op.in]: ids } },
        order: [['posted_at', 'DESC']],
      });
    }
  },

  feedByUserId: {
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
    },
    resolve: async (_, { userId, limit, offset }) => {
      let feed = UserFeeds.get(userId);

      if (!feed || isExpired(feed.createdAt)) {
        feed = await FeedService.getFeed(userId);
        UserFeeds.set(userId, feed);
      }

      const ids = slice(feed.postIds, limit, offset);
      return Post.findAll({
        where: { id: { [Op.in]: ids } },
        order: [['posted_at', 'DESC']],
      });
    }
  }
};
