import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import sequelize from '../sequelize';
import Store from '../models/Store/Store';
import UserAccount from '../models/User/UserAccount';
import PostType, { PostTypeValues } from '../types/Post/PostType';
import { ScoreType } from '../types/Post/PostReviewType';
import PostReview from '../models/Post/PostReview';
import Post from '../models/Post/Post';
import PostPhoto from '../models/Post/PostPhoto';
import PostPhotoType from '../types/Post/PostPhotoType';

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
      if (store == null) throw Error(`Could not find Store by storeId: "${storeId}"`);
      let user = await UserAccount.findByPk(postedById);
      if (user == null) throw Error(`Could not find UserAccount by userId: "${postedById}"`);
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
            return { post_id: post.id, url: p }
          });
          await PostPhoto.bulkCreate(postPhotos, { returning: true, transaction: t });
        }
        return post;
      });
    }
  },
  updatePost: {
    type: PostType,
    args: {
      id: {
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
    },
    resolve: async (
      _,
      { id, body, overallScore, tasteScore, serviceScore, valueScore, ambienceScore, photos },
    ) => {
      let post = await Post.findByPk(id);
      if (post == null) throw Error(`Could not find Post by postId: "${id}"`);
      return sequelize.transaction(async t => {
        await post.update({
            overall_score: overallScore,
            taste_score: tasteScore,
            service_score: serviceScore,
            value_score: valueScore,
            ambience_score: ambienceScore,
            body: body,
        }, {transaction: t});
        if (photos.length > 0) {
          const postPhotos = photos.map((p) => {
            return { post_id: id, url: p }
          });
          await PostPhoto.bulkCreate(postPhotos, { returning: true, transaction: t });
        }
        return post;
      });
    }
  },
  deletePost: {
    type: PostType,
    args: {
      postId: {
        type: new NonNull(Int),
      },
      myId: {
        type: new NonNull(Int)
      }
    },
    resolve: async (
      _,
      { postId, myId },
    ) => {
      let post = await Post.findByPk(postId);
      if (post == null) throw Error(`Could not find Post by postId: "${postId}"`);
      let user = await UserAccount.findByPk(myId);
      if (user == null) throw Error(`Could not find UserAccount by userId: "${myId}"`);
      if (post.posted_by_id !== myId) throw Error(`You must be the owner of the post to delete the post`);
      await post.destroy();
      return post;
    }
  },
  deletePhoto: {
    type: PostPhotoType,
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: async (
      _,
      { id },
    ) => {
      let photo = await PostPhoto.findByPk(id);
      if (photo == null) throw Error(`Could not find PostPhoto by id: "${id}"`);
      await photo.destroy();
      return photo;
    }
  }
};
