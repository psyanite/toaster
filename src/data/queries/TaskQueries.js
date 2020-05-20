import { GraphQLString as String } from 'graphql';
import sequelize from '../sequelize';
import { Reward, Store } from '../models';

export default {
  refreshMaterializedViews: {
    type: String,
    resolve: async () => {
      await sequelize.query(`refresh materialized view location_search`);
      await sequelize.query(`refresh materialized view cuisine_search`);
      await sequelize.query(`refresh materialized view store_search`);
      await sequelize.query(`refresh materialized view reward_search`);
      return `Updated materialized views location_search, cuisine_search, store_search reward_search`;
    }
  },

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
          set rank = (case when rr.valid_from < now() and now() < rr.valid_to then rr.rank else 99 end)
          from store_rankings rr
          where stores.id = rr.store_id
        `);
      const total = await Store.count();
      return `Updated ${firstUpdate.rowCount + secondUpdate.rowCount} stores out of ${total} stores`;
    }
  },

  updateStoreFollowerCount: {
    type: String,
    resolve: async () => {
      const [, result] = await sequelize
        .query(`
          with counted as (
           select store_id, count(*) as follow_count
           from store_follows
           group by store_id
          )
          update stores set follower_count = c.follow_count
          from counted c where c.store_id = stores.id
        `);
      return `Updated follower counts for ${result.rowCount} stores`;
    }
  },

  updateUserFollowerCount: {
    type: String,
    resolve: async () => {
      const [, result] = await sequelize
        .query(`
          with counted as (
           select user_id, count(*) as follow_count
           from user_follows
           group by user_id
          )
          update user_profiles set follower_count = c.follow_count
          from counted c where c.user_id = user_profiles.user_id
        `);
      return `Updated follower counts for ${result.rowCount} user profiles`;
    }
  },

  updateReviewCount: {
    type: String,
    resolve: async () => {
      const [, result] = await sequelize
        .query(`
          with counted as (
            select posted_by, count(*) as count from (
              select posted_by, store_id
              from posts
              group by posted_by, store_id
            ) as t
            group by posted_by
          )
          update user_profiles
          set store_count = c.count
          from counted c
          where c.posted_by = user_profiles.user_id;
        `);
      return `Updated store counts for ${result.rowCount} user profiles`;
    }
  },

  updateRewardCoords: {
    type: String,
    resolve: async () => {
      const [, firstUpdate] = await sequelize
        .query(`
          update rewards r
          set coords = array[s.coords]
          from stores s
          where r.store_id = s.id
        `);
      const [, secondUpdate] = await sequelize
        .query(`
          update rewards r
          set coords = array(
            select s.coords
            from stores s
              left join store_group_stores sgs on sgs.store_id = s.id
            where r.store_group_id = sgs.group_id
            )
          where store_group_id is not null
        `);
      const total = await Reward.count();
      return `Updated ${firstUpdate.rowCount + secondUpdate.rowCount} rewards out of ${total} rewards`;
    }
  },
};
