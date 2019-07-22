/* eslint-disable no-param-reassign */
import { GraphQLString as String } from 'graphql';
import sequelize from '../sequelize';

export default {
  updatePostLikeCommentCache: {
    type: String,
    resolve: async () => {
      const [, likeResult] = await sequelize
        .query(`
          WITH counted AS (
             SELECT post_id, count(*) AS like_count
             FROM user_favorite_posts
             GROUP BY post_id
          )
          UPDATE posts SET like_count = c.like_count
          FROM counted c WHERE c.post_id = posts.id
        `);
      const [, commentResult] = await sequelize
        .query(`
          WITH counted AS (
             SELECT post_id, count(*) AS comments_count
             FROM comments
             GROUP BY post_id
          )
          UPDATE posts SET comment_count = c.comments_count
          FROM counted c WHERE c.post_id = posts.id
        `);
      return `Updated ${likeResult.rowCount} like counts, and ${commentResult.rowCount} comment counts`;
    }
  },
};
