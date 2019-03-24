import {
  GraphQLEnumType as EnumType,
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
} from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Post, PostPhoto, PostReview, Store, UserAccount } from '../../models';
import StoreType from '../Store/StoreType';
import UserAccountType from '../User/UserAccountType';
import PostPhotoType from '../Post/PostPhotoType';
import PostReviewType from '../Post/PostReviewType';

Post.Store = Post.belongsTo(Store, { foreignKey: 'store_id' });
Post.UserAccount = Post.belongsTo(UserAccount, { foreignKey: 'posted_by_id' });
Post.PostPhotos = Post.hasMany(PostPhoto, { as: 'Photos' });
Post.PostReview = Post.hasOne(PostReview);

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
    store: {
      type: StoreType,
      resolve: resolver(Post.Store),
    },
    posted_by: {
      type: UserAccountType,
      resolve: resolver(Post.UserAccount),
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
  }),
});
