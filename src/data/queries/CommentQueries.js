/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String} from 'graphql';
import { Comment, Reply } from '../models';
import CommentType from '../types/Post/CommentType';
import ReplyType from '../types/Post/ReplyType';
import FcmService from '../services/FcmService';

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
  },

  test: {
    type: String,
    resolve: async () => {
      var token = 'f5ivSDtq98c:APA91bFiEbPtBEYN1tNhCS8tn0J-cMtKfYLMzfQtUkDGLUVq1BbPsSzmWViQ5UyvCqMgOACK1AHy3Njj10jh95uXq70mcom55TdWOlSrAAUywgebQi_jSNB-0b2jBNhDRWjCzQQiyGxP';
      await FcmService.sendMessage('meow', token, 'title', 'message');
      console.log("meow");
      return "meow";
    }
  }
};
