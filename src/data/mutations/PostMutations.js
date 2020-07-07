import {
  GraphQLBoolean as Boolean,
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLString as String
} from 'graphql';

import sequelize from '../sequelize';

import { Post, PostPhoto, PostReview, Store, UserAccount, UserProfile } from '../models';
import PostType, { PostTypeValues } from '../types/Post/PostType';
import { ScoreType } from '../types/Post/PostReviewType';
import PostPhotoType from '../types/Post/PostPhotoType';

import Utils from '../../utils/Utils';
import FcmService from '../services/FcmService';

async function notifyNewPost(post) {
  try {
    const adminUserProfiles = await sequelize
      .query(`
        select user_profiles.*
        from user_profiles
               join admins a on user_profiles.admin_id = a.id
        where a.store_id = :storeId;
      `, {
        model: UserProfile,
        replacements: { storeId: post.store_id },
      });
    const fcmTokens = adminUserProfiles.map(p => p.fcm_token).filter(e => e);

    if (fcmTokens.length <= 0) return;

    const messenger = FcmService.fcm.butter;
    const postedBy = await UserProfile.findByPk(post.posted_by);

    fcmTokens.forEach(fcmToken => {
      FcmService.notifyPost(messenger, {
        token: fcmToken,
        title: postedBy.username,
        body: 'Posted a new review for your store',
        image: postedBy.profile_picture,
        postId: post.id,
      })
    });

  } catch (e) {
    Utils.error(() => console.error(e, e.stack));
  }
}

export default {
  addPost: {
    type: PostType,
    args: {
      hidden: {
        type: new NonNull(Boolean),
      },
      official: {
        type: new NonNull(Boolean),
      },
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
      postedBy: {
        type: new NonNull(Int),
      },
    },
    resolve: async (
      _,
      { hidden, official, storeId, body, overallScore, tasteScore, serviceScore, valueScore, ambienceScore, photos, postedBy },
    ) => {
      let store = await Store.findByPk(storeId);
      if (store == null) throw Error(`Could not find Store by storeId: ${storeId}`);
      let user = await UserProfile.findByPk(postedBy);
      if (user == null) throw Error(`Could not find UserProfile by userId: ${postedBy}`);

      const process = async (t) => {
        const post = await Post.create({
            type: PostTypeValues.Review,
            hidden: hidden,
            official: official,
            store_id: storeId,
            posted_by: postedBy,
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
      };

      try {
        const post = await sequelize.transaction(process);
        if (user.admin_id == null) notifyNewPost(post).then(() => {});
        return post;
      } catch (err) {
        Utils.error(err.errors);
        throw Error(`Could not add post: ${err}`);
      }
    }
  },

  updatePost: {
    type: PostType,
    args: {
      id: {
        type: new NonNull(Int),
      },
      hidden: {
        type: new NonNull(Boolean),
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
      { id, hidden, body, overallScore, tasteScore, serviceScore, valueScore, ambienceScore, photos },
    ) => {
      let post = await Post.findByPk(id);
      if (post == null) throw Error(`Could not find Post by postId: ${id}`);
      let postReview = await PostReview.findOne({ where: { post_id: id } });
      return sequelize.transaction(async t => {
        await post.update({
          hidden: hidden,
        }, { transaction: t });
        await postReview.update({
          overall_score: overallScore,
          taste_score: tasteScore,
          service_score: serviceScore,
          value_score: valueScore,
          ambience_score: ambienceScore,
          body: body,
        }, { transaction: t });
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
      if (post == null) throw Error(`Could not find Post by postId: ${postId}`);
      if (post.posted_by !== myId) throw Error(`You must be the owner of the post to delete the post`);
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
      if (photo == null) throw Error(`Could not find PostPhoto by id: ${id}`);
      await photo.destroy();
      return photo;
    }
  }
};
