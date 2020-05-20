import {
  GraphQLBoolean as Boolean,
  GraphQLEnumType as EnumType,
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
} from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Comment, Post, PostPhoto, PostReview, Store, UserProfile } from '../../models';
import StoreType from '../Store/StoreType';
import UserProfileType from '../User/UserProfileType';
import PostPhotoType from '../Post/PostPhotoType';
import PostReviewType from '../Post/PostReviewType';
import CommentType from '../Post/CommentType';

Post.Store = Post.belongsTo(Store, { foreignKey: 'store_id' });
Post.UserProfile = Post.belongsTo(UserProfile, { foreignKey: 'posted_by' });
Post.PostPhotos = Post.hasMany(PostPhoto, { as: 'Photos' });
Post.PostReview = Post.hasOne(PostReview);
Post.Comments = Post.hasMany(Comment, { as: 'Comments' });

export const PostTypeValues = Object.freeze({
  Photo: 'photo',
  Review: 'review',
});

export const PostType = new EnumType({
  name: 'PostType',
  values: {
    photo: { value: PostTypeValues.Photo },
    review: { value: PostTypeValues.Review },
  },
});

export default new ObjectType({
  name: 'Post',
  fields: () => ({
    id: { type: new NonNull(Int) },
    type: { type: PostType },
    hidden: { type: Boolean },
    official: { type: Boolean },
    store: {
      type: StoreType,
      resolve: resolver(Post.Store),
    },
    posted_by: {
      type: UserProfileType,
      resolve: resolver(Post.UserProfile),
    },
    posted_at: { type: DateTime },
    post_photos: {
      type: new List(PostPhotoType),
      resolve: resolver(Post.PostPhotos),
    },
    post_review: {
      type: PostReviewType,
      resolve: resolver(Post.PostReview),
    },
    comments: {
      type: new List(CommentType),
      resolve: resolver(Post.Comments),
    },
    like_count: { type: new NonNull(Int) },
    comment_count: { type: new NonNull(Int) },
  }),
});
