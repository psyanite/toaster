import { GraphQLInt as Int, GraphQLString as String, GraphQLNonNull as NonNull } from 'graphql';
import { QueryTypes } from 'sequelize';

import sequelize from '../sequelize';
import { Reward, Store, UserProfile, UserAccount } from '../models';
import BucketService from '../services/BucketService';
import FcmService from '../services/FcmService';
import Utils from '../../utils/Utils';
import configs, { Env } from '../../configs';

export default {

  addMeow: {
    type: Int,
    args: {
      username: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { username }) => {
      if (configs.envCode !== 'DEV') return 3;

      const email = `${username}@gmeow.com`
      const userAccount = await UserAccount.create({ email });

      await UserProfile.create({
        user_id: userAccount.id,
        username,
        preferred_name: null,
        profile_picture: 'https://i.imgur.com/5gnUT3I.jpg',
        code: Utils.generateCode(),
      });

      return 1;
    }
  },

  cooper: {
    type: Int,
    resolve: async () => {
      const result = await sequelize
        .query(`
          select reltuples
          from pg_catalog.pg_class
          where relname = 'stores'
        `, { type: QueryTypes.SELECT });

      try {
        return parseInt(result[0]['reltuples'], 10);
      } catch (e) {
        const msg = `Failed response: ${JSON.stringify(result)}`;
        Utils.error(() => {
          console.error(msg);
          console.error(e);
        });
        return msg;
      }
    },
  },

  backupBuckets: {
    type: String,
    resolve: () => {
      if (configs.envCode !== "PROD") return 'Disabled';
      BucketService.backupBurntoastBucket().then(() => null);
      BucketService.backupButterBucket().then(() => null);
      return 'Started';
    },
  },

  testNotification: {
    type: String,
    resolve: async () => {
      const user = await UserProfile.findByPk(2);
      try {
        return FcmService.notifyPost(FcmService.fcm.burntoast, {
          token: user.fcm_token,
          title: 'perrylicious',
          body: 'Replied to your comment: Can\'t wait to come here next Friday!!! 🥩',
          postId: '134',
          flashReply: '92',
          image: 'https://i.imgur.com/5gnUT3I.jpg',
        });
      } catch (e) {
        Utils.error(() => console.error(e, e.stack));
      }
    },
  },

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
          update posts
          set like_count = c.like_count
          from counted c
          where c.post_id = posts.id
        `);
      const [, commentResult] = await sequelize
        .query(`
          with counted as (
            select post_id, count(*) as comments_count
            from comments
            group by post_id
          )
          update posts
          set comment_count = c.comments_count
          from counted c
          where c.post_id = posts.id
        `);
      const result = likeResult.rowCount > 0 && commentResult.rowCount > 0 ? 'Success' : 'Failed';
      return `${result}, updated ${likeResult.rowCount} like counts, and ${commentResult.rowCount} comment counts`;
    }
  },

  updateRewardRankings: {
    type: String,
    resolve: async () => {
      const [, firstUpdate] = await sequelize
        .query(`
          update rewards
          set rank = 99
          where not exists(
              select true
              from reward_rankings
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
      const updatedCount = firstUpdate.rowCount + secondUpdate.rowCount;
      const total = await Reward.count();
      const result = updatedCount === total ? 'Success' : 'Failed';
      return `${result}, updated ${updatedCount} / ${total} rewards`;
    }
  },

  updateStoreRankings: {
    type: String,
    resolve: async () => {
      const [, firstUpdate] = await sequelize
        .query(`
          update stores
          set rank = 99
          where not exists(
              select true
              from store_rankings
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
      const updatedCount = firstUpdate.rowCount + secondUpdate.rowCount;
      const result = updatedCount === total ? 'Success' : 'Failed';
      return `${result}, updated ${updatedCount} / ${total} stores`;
    }
  },

  updateStoreFollowerCount: {
    type: String,
    resolve: async () => {
      const [, updated] = await sequelize
        .query(`
          with counted as (
            select store_id, count(*) as follow_count
            from store_follows
            group by store_id
          )
          update stores
          set follower_count = c.follow_count
          from counted c
          where c.store_id = stores.id
        `);
      const result = updated.rowCount > 0 ? 'Success' : 'Failed';
      return `${result}, updated follower counts for ${updated.rowCount} stores`;
    }
  },

  updateUserFollowerCount: {
    type: String,
    resolve: async () => {
      const [, updated] = await sequelize
        .query(`
          with counted as (
            select user_id, count(*) as follow_count
            from user_follows
            group by user_id
          )
          update user_profiles
          set follower_count = c.follow_count
          from counted c
          where c.user_id = user_profiles.user_id
        `);
      const result = updated.rowCount > 0 ? 'Success' : 'Failed';
      return `${result}, updated follower counts for ${updated.rowCount} user profiles`;
    }
  },

  updateReviewCount: {
    type: String,
    resolve: async () => {
      const [, updated] = await sequelize
        .query(`
          with counted as (
            select posted_by, count(*) as count
            from (
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
      const result = updated.rowCount > 0 ? 'Success' : 'Failed';
      return `${result}, updated store counts for ${updated.rowCount} user profiles`;
    }
  },

  updateRewardCoords: {
    type: String,
    resolve: async () => {
      const [, firstUpdate] = await sequelize
        .query(`
          update rewards r
          set coords = array [s.coords]
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
      const updatedCount = firstUpdate.rowCount + secondUpdate.rowCount;
      const total = await Reward.count();
      const result = updatedCount === total ? 'Success' : 'Failed';
      return `${result}, updated ${updatedCount} / ${total} rewards`;
    }
  },
};
