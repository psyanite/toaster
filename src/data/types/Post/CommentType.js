import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String
} from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Comment, CommentLike, Reply, UserAccount } from '../../models';
import ReplyType from '../Post/ReplyType';
import UserAccountType from '../User/UserAccountType';
import CommentLikeType from './CommentLikeType';

Comment.Replies = Comment.hasMany(Reply, { as: 'replies' });
Comment.Likers = Comment.hasMany(CommentLike, { foreignKey: 'comment_id', as: 'likers' });
Comment.UserAccount = Comment.belongsTo(UserAccount, { foreignKey: 'commented_by' });

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
    liked_by: {
      type: new List(CommentLikeType),
      resolve: resolver(Comment.Likers),
    },
    commented_by: {
      type: UserAccountType,
      resolve: resolver(Comment.UserAccount),
    },
    commented_at: { type: DateTime },
  }),
});
