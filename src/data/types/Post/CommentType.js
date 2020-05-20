import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String
} from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Comment, CommentLike, Reply, Store, UserProfile } from '../../models';
import ReplyType from '../Post/ReplyType';
import UserProfileType from '../User/UserProfileType';
import CommentLikeType from './CommentLikeType';
import StoreType from '../Store/StoreType';

Comment.Replies = Comment.hasMany(Reply, { as: 'replies' });
Comment.Likes = Comment.hasMany(CommentLike, { foreignKey: 'comment_id', as: 'likes' });
Comment.UserProfile = Comment.belongsTo(UserProfile, { foreignKey: 'commented_by' });
Comment.Store = Comment.belongsTo(Store, { foreignKey: 'commented_by_store' });

export default new ObjectType({
  name: 'Comment',
  fields: () => ({
    id: { type: new NonNull(Int) },
    post_id: { type: new NonNull(Int) },
    body: { type: String },
    replies: {
      type: new List(ReplyType),
      resolve: resolver(Comment.Replies),
    },
    likes: {
      type: new List(CommentLikeType),
      resolve: resolver(Comment.Likes),
    },
    commented_by: {
      type: UserProfileType,
      resolve: resolver(Comment.UserProfile),
    },
    commented_by_store: {
      type: StoreType,
      resolve: resolver(Comment.Store),
    },
    commented_at: { type: DateTime },
  }),
});
