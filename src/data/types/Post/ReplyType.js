import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String
} from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Reply, ReplyLike, UserProfile } from '../../models';
import UserProfileType from '../User/UserProfileType';
import ReplyLikeType from './ReplyLikeType';

Reply.Likers = Reply.hasMany(ReplyLike, { foreignKey: 'reply_id', as: 'likers' });
Reply.UserProfile = Reply.belongsTo(UserProfile, { foreignKey: 'replied_by' });

export default new ObjectType({
  name: 'Reply',
  fields: () => ({
    id: { type: new NonNull(Int) },
    comment_id: { type: new NonNull(Int) },
    body: { type: String },
    liked_by: {
      type: new List(ReplyLikeType),
      resolve: resolver(Reply.Likers),
    },
    replied_by: {
      type: UserProfileType,
      resolve: resolver(Reply.UserProfile),
    },
    replied_at: { type: DateTime },
  }),
});