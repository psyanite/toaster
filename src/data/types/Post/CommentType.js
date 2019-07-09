import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String, GraphQLList as List } from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Post, Reply, UserAccount, Comment } from '../../models';
import PostType from '../Post/PostType';
import ReplyType from '../Post/ReplyType';
import UserAccountType from '../User/UserAccountType';

Comment.Post = Comment.belongsTo(Post, { foreignKey: 'post_id' });
Comment.UserAccount = Comment.belongsTo(UserAccount, { foreignKey: 'commented_by' });
Comment.Replies = Comment.hasMany(Reply, { as: 'Replies' });

export default new ObjectType({
  name: 'Comment',
  fields: () => ({
    id: { type: new NonNull(Int) },
    post: {
      type: PostType,
      resolve: resolver(Comment.Post),
    },
    body: { type: String },
    replies: {
      type: new List(ReplyType),
      resolve: resolver(Comment.Replies),
    },
    commented_by: {
      type: UserAccountType,
      resolve: resolver(Comment.UserAccount),
    },
    commented_at: { type: DateTime },
  }),
});
