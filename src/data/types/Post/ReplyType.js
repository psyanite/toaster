import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String
} from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';
import { Reply, ReplyLike, UserProfile, Store } from '../../models';
import UserProfileType from '../User/UserProfileType';
import ReplyLikeType from './ReplyLikeType';
import StoreType from '../Store/StoreType';

Reply.Likes = Reply.hasMany(ReplyLike, { foreignKey: 'reply_id', as: 'likes' });
Reply.UserProfile = Reply.belongsTo(UserProfile, { foreignKey: 'replied_by' });
Reply.Store = Reply.belongsTo(Store, { foreignKey: 'replied_by_store' });

export default new ObjectType({
  name: 'Reply',
  fields: () => ({
    id: { type: new NonNull(Int) },
    comment_id: { type: new NonNull(Int) },
    body: { type: String },
    likes: {
      type: new List(ReplyLikeType),
      resolve: resolver(Reply.Likes),
    },
    replied_by: {
      type: UserProfileType,
      resolve: resolver(Reply.UserProfile),
    },
    replied_by_store: {
      type: StoreType,
      resolve: resolver(Reply.Store),
    },
    replied_at: { type: DateTime },
  }),
});
