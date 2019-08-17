/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull } from 'graphql';
import PostType from '../types/Post/PostType';
import FeedService, { Feed } from '../services/FeedService';

const UserFeeds = new Map();
let DefaultFeed = new Feed(null);

export default {
  feedByDefault: {
    type: new List(PostType),
    resolve: async () => {
      if (DefaultFeed.posts == null || DefaultFeed.createdAt < new Date(new Date() - 10*60000)) {
        DefaultFeed = await FeedService.getGenericFeed();
      }
      return DefaultFeed.posts.values();
    }
  },

  feedByUserId: {
    type: new List(PostType),
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId }) => {
      let exist = UserFeeds.get(userId);

      let feed;
      if (!feed) {
        feed = await FeedService.getFeed(userId);
      } else if (exist.createdAt < new Date(new Date() - 10*60000)) {
        feed = await FeedService.getFeed(userId);
      } else {
        return exist.posts.values();
      }

      UserFeeds.set(userId, feed);

      return feed.posts.values();
    }
  }
};
