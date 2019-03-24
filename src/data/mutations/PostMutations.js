import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import sequelize from '../sequelize';
import Store from '../models/Store/Store';
import UserAccount from '../models/User/UserAccount';
import PostType, { PostTypeValues } from '../types/Post/PostType';
import { ScoreType } from '../types/Post/PostReviewType';
import PostReview from '../models/Post/PostReview';
import Post from '../models/Post/Post';
import PostPhoto from '../models/Post/PostPhoto';

export default {
  addReviewPost: {
    type: PostType,
    args: {
      storeId: {
        type: new NonNull(Int),
      },
      body: {
        type: String,
      },
      overallScore: {
        type: ScoreType,
      },
      tasteScore: {
        type: ScoreType,
      },
      serviceScore: {
        type: ScoreType,
      },
      valueScore: {
        type: ScoreType,
      },
      ambienceScore: {
        type: ScoreType,
      },
      photos: {
        type: new List(String),
      },
      postedById: {
        type: new NonNull(Int),
      },
    },
    resolve: async (
      _,
      { storeId, body, overallScore, tasteScore, serviceScore, valueScore, ambienceScore, photos, postedById },
    ) => {
      let store = await Store.findByPk(storeId);
      if (store == null) throw Error(`Could not find Store by storeId [${storeId}]`);
      let user = await UserAccount.findByPk(postedById);
      if (user == null) throw Error(`Could not find UserAccount by userId [${postedById}]`);
      return sequelize.transaction(async t => {
        const post = await Post.create({
            type: PostTypeValues.Review,
            store_id: storeId,
            posted_by_id: postedById,
          }, { transaction: t },
        );
        await PostReview.create({
            post_id: post.id,
            overall_score: overallScore,
            taste_score: tasteScore,
            service_score: serviceScore,
            value_score: valueScore,
            ambience_score: ambienceScore,
            body: body,
          }, { transaction: t },
        );
        if (photos.length > 0) {
          const postPhotos = photos.map((p) => {
            return { post_id: post.id, photo: p }
          });
          await PostPhoto.bulkCreate(postPhotos, { returning: true, transaction: t });
        }
        return post;
      });
    }
  }
};
