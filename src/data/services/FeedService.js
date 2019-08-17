import { Post } from '../models';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';

const Op = Sequelize.Op;

let LastFetchedTopPosts = null;
let TopUserPosts = null;
let TopStorePosts = null;

export class Feed {
  constructor(posts) {
    this.createdAt = new Date();
    this.posts = posts;
  }
}

const getFollowedUsersPosts = async (userId) => {
  const [userIds] = await sequelize
    .query(`
      select user_id
      from user_follows
      where follower_id = :userId;
    `, {
      replacements: { userId: userId }
    });
  if (!userIds || userIds.length === 0) {
    return [];
  }

  return await Post.findAll({
    limit: 30,
    where: {
      posted_by: {
        [Op.in]: userIds.map(u => u.user_id)
      }
    },
    order: [['posted_at', 'DESC']]
  })
};

const getFollowedStoresPosts = async (userId) => {
  const [storeIds] = await sequelize
    .query(`
      select store_id
      from store_follows
      where follower_id = :userId;
    `, {
      replacements: { userId: userId }
    });
  if (!storeIds || storeIds.length === 0) {
    return [];
  }

  return await Post.findAll({
    limit: 30,
    where: {
      store_id: {
        [Op.in]: storeIds.map(s => s.store_id)
      }
    },
    order: [['posted_at', 'DESC']]
  })
};

const refreshTopPosts = async () => {
  let fetchTopUserPosts = Post.findAll({
    limit: 50,
    where: {
      posted_by: {
        [Op.ne]: null
      }
    },
    order: [['posted_at', 'DESC']]
  });
  let fetchTopStorePosts = Post.findAll({
    limit: 50,
    where: {
      posted_by: {
        [Op.eq]: null
      }
    },
    order: [['posted_at', 'DESC']]
  });
  TopUserPosts = await fetchTopUserPosts;
  TopStorePosts = await fetchTopStorePosts;
};

const getTopStorePosts = (limit) => {
  if (LastFetchedTopPosts < new Date(new Date() - 5*60000)) refreshTopPosts();
  return TopStorePosts.slice(0, limit || 25);
};

const getTopUserPosts = (limit) => {
  if (LastFetchedTopPosts < new Date(new Date() - 5*60000)) refreshTopPosts();
  return TopUserPosts.slice(0, limit || 25);
};

const toMap = (input) => {
  let posts = input.length > 60 ? input.slice(0, 60) : input;
  posts.sort((a, b) => {
    return new Date(b.posted_at) - new Date(a.posted_at);
  });
  return posts.reduce((map, post) => {
    map.set(post.id, post);
    return map;
  }, new Map());
};

refreshTopPosts();

export default class FeedService {

  static async getGenericFeed() {
    const topStorePosts = getTopStorePosts(30);
    const topUserPosts = getTopUserPosts(30);
    return new Feed(toMap([...topStorePosts, ...topUserPosts]));
  }

  static async getFeed(userId) {
    const [userPosts, storePosts] = await Promise.all([getFollowedUsersPosts(userId), getFollowedStoresPosts(userId)]);
    let posts = [...userPosts, ...storePosts];
    if (posts.length > 60) {
      const topStorePosts = getTopStorePosts(10);
      return new Feed(toMap([...posts, ...topStorePosts]));
    }

    const remainder = 60 - posts.length;
    const topStorePosts = getTopStorePosts(Math.round(remainder * 0.7));
    const topUserPosts = getTopUserPosts(Math.round(remainder * 0.3));
    return new Feed(toMap([...posts, ...topStorePosts, ...topUserPosts]));
  }
}
