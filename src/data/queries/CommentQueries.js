/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, } from 'graphql';
import { Comment, Reply } from '../models';
import CommentType from '../types/Post/CommentType';
import ReplyType from '../types/Post/ReplyType';

export default {
  commentsByPostId: {
    type: new List(CommentType),
    args: {
      postId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { postId }) => {
      return Comment.findAll({ where: { post_id: postId } });
    }
  },

  allReplies: {
    type: new List(ReplyType),
    resolve() {
      return Reply.findAll().then(data => data)
    }
  }
};
