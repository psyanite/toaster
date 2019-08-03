/* eslint-disable no-param-reassign */
import { GraphQLString as String } from 'graphql';
import sequelize from '../sequelize';
import { Store, Reward } from '../models';

export default {
  updatePostLikeCommentCache: {
    type: String,
    resolve: async () => {
      const [, likeResult] = await sequelize
        .query(`
          with counted as (
             select post_id, count(*) as like_count
             from user_favorite_posts
             group by post_id
          )
          update posts set like_count = c.like_count
          from counted c where c.post_id = posts.id
        `);
      const [, commentResult] = await sequelize
        .query(`
          with counted as (
             select post_id, count(*) as comments_count
             from comments
             group by post_id
          )
          update posts set comment_count = c.comments_count
          from counted c where c.post_id = posts.id
        `);
      return `Updated ${likeResult.rowCount} like counts, and ${commentResult.rowCount} comment counts`;
    }
  },

  updateRewardRankings: {
    type: String,
    resolve: async () => {
      const [, firstUpdate] = await sequelize
        .query(`
          update rewards
          set rank = 99
          where not exists (
            select true from reward_rankings
            where reward_rankings.reward_id = rewards.id
          )
        `);
      const [, secondUpdate] = await sequelize
        .query(`
          update rewards
          set rank = (case when rr.valid_from < now() and now() < rr.valid_to then rr.rank else 99 end)
          from reward_rankings rr
          where rewards.id = rr.reward_id
        `);
      const total = await Reward.count();
      return `Updated ${firstUpdate.rowCount + secondUpdate.rowCount} rewards out of ${total} rewards`;
    }
  },

  updateStoreRankings: {
    type: String,
    resolve: async () => {
      const [, firstUpdate] = await sequelize
        .query(`
          update stores
          set rank = 99
          where not exists (
            select true from store_rankings
            where store_rankings.store_id = stores.id
          )
        `);
      const [, secondUpdate] = await sequelize
        .query(`
          update stores
          set rank = rr.rank
          from store_rankings rr
          where stores.id = rr.store_id
            and rr.valid_from < now()
            and now() < rr.valid_to
        `);
      const total = await Store.count();
      return `Updated ${firstUpdate.rowCount + secondUpdate.rowCount} stores out of ${total} stores`;
    }
  },
};
