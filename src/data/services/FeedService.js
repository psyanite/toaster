import { Post } from '../models';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';

const Op = Sequelize.Op;

let LastFetchedTopPosts = null;
let TopUserPosts = null;
let TopStorePosts = null;

export class Feed {
  constructor(posts) {
    let slicedPosts = posts.length > 60 ? posts.slice(0, 60) : posts;
    slicedPosts.sort((a, b) => {
      return new Date(b.posted_at) - new Date(a.posted_at);
    });

    this.createdAt = new Date();
    this.postIds = slicedPosts.map((p) => p.id);
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

  return Post.findAll({
    limit: 30,
    where: {
      posted_by: {
        [Op.in]: userIds.map(u => u.user_id)
      }
    },
    order: [['posted_at', 'DESC']]
  });
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

  return Post.findAll({
    limit: 30,
    where: {
      store_id: {
        [Op.in]: storeIds.map(s => s.store_id)
      }
    },
    order: [['posted_at', 'DESC']]
  });
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
  LastFetchedTopPosts = new Date();
};

const topPostsAreStale = () => {
  return LastFetchedTopPosts == null || LastFetchedTopPosts < new Date(new Date() - 5*60000);
};

const getTopStorePosts = async (limit) => {
  if (topPostsAreStale) await refreshTopPosts();
  return TopStorePosts.slice(0, limit || 25);
};

const getTopUserPosts = async (limit) => {
  if (topPostsAreStale) await refreshTopPosts();
  return TopUserPosts.slice(0, limit || 25);
};

refreshTopPosts();

export default class FeedService {

  static async getGenericFeed() {
    const topStorePosts = await getTopStorePosts(30);
    const topUserPosts = await getTopUserPosts(30);
    return new Feed([...topStorePosts, ...topUserPosts]);
  }

  static async getFeed(userId) {
    const [userPosts, storePosts] = await Promise.all([getFollowedUsersPosts(userId), getFollowedStoresPosts(userId)]);
    let posts = [...userPosts, ...storePosts];
    if (posts.length > 60) {
      const topStorePosts = await getTopStorePosts(10);
      return new Feed([...posts, ...topStorePosts]);
    }

    const remainder = 60 - posts.length;
    const topStorePosts = await getTopStorePosts(Math.round(remainder * 0.7));
    const topUserPosts = await getTopUserPosts(Math.round(remainder * 0.3));
    return new Feed([...posts, ...topStorePosts, ...topUserPosts]);
  }
}
