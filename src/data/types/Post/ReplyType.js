import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String } from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Reply, UserAccount, Comment } from '../../models';
import CommentType from '../Post/CommentType';
import UserAccountType from '../User/UserAccountType';

Reply.Comment = Reply.belongsTo(Comment, { foreignKey: 'comment_id' });
Reply.UserAccount = Reply.belongsTo(UserAccount, { foreignKey: 'replied_by' });

export default new ObjectType({
  name: 'Reply',
  fields: () => ({
    id: { type: new NonNull(Int) },
    comment: {
      type: CommentType,
      resolve: resolver(Reply.Comment),
    },
    body: { type: String },
    replied_by: {
      type: UserAccountType,
      resolve: resolver(Reply.UserAccount),
    },
    replied_at: { type: DateTime },
  }),
});
