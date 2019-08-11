import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import UserAccount from '../models/User/UserAccount';
import Post from '../models/Post/Post';
import Reply from '../models/Post/Reply';
import Comment from '../models/Post/Comment';
import CommentType from '../types/Post/CommentType';
import ReplyType from '../types/Post/ReplyType';
import ReplyLike from '../models/Post/ReplyLike';
import ReplyLikeType from '../types/Post/ReplyLikeType';
import CommentLikeType from '../types/Post/CommentLikeType';
import CommentLike from '../models/Post/CommentLike';

export default {
  addComment: {
    type: CommentType,
    args: {
      postId: {
        type: new NonNull(Int),
      },
      body: {
        type: String,
      },
      commentedBy: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { postId, body, commentedBy }) => {
      let post = await Post.findByPk(postId);
      if (post == null) throw Error(`Could not find Post by postId: ${postId}`);
      let user = await UserAccount.findByPk(commentedBy);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${commentedBy}`);
      const comment = await Comment.create({
        post_id: postId,
        body: body,
        commented_by: commentedBy
      });
      await post.increment('comment_count');
      return comment;
    }
  },

  deleteComment: {
    type: CommentType,
    args: {
      myId: {
        type: new NonNull(Int)
      },
      commentId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { myId, commentId }) => {
      let comment = await Comment.findByPk(commentId);
      if (comment == null) throw Error(`Could not find Comment by commentId: ${commentId}`);
      let user = await UserAccount.findByPk(myId);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${myId}`);
      if (comment.commented_by !== myId) throw Error(`You must be the owner of the comment to delete the comment`);
      await comment.destroy();
      await Post.decrement('comment_count', { where: { id: comment.post_id }});
      return comment;
    }
  },

  addReply: {
    type: ReplyType,
    args: {
      commentId: {
        type: new NonNull(Int),
      },
      body: {
        type: String,
      },
      repliedBy: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { commentId, body, repliedBy }) => {
      let comment = await Comment.findByPk(commentId);
      if (comment == null) throw Error(`Could not find Comment by commentId: ${commentId}`);
      let user = await UserAccount.findByPk(repliedBy);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${repliedBy}`);
      return await Reply.create({
        comment_id: commentId,
        body: body,
        replied_by: repliedBy
      });
    }
  },

  deleteReply: {
    type: ReplyType,
    args: {
      myId: {
        type: new NonNull(Int)
      },
      replyId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { myId, replyId }) => {
      let reply = await Reply.findByPk(replyId);
      if (reply == null) throw Error(`Could not find Reply by replyId: ${replyId}`);
      let user = await UserAccount.findByPk(myId);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${myId}`);
      if (reply.replied_by !== myId) throw Error(`You must be the owner of the reply to delete the reply`);
      await reply.destroy();
      return reply;
    }
  },

  favoriteComment: {
    type: CommentLikeType,
    args: {
      myId: {
        type: new NonNull(Int)
      },
      commentId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { myId, commentId }) => {
      let comment = await Comment.findByPk(commentId);
      if (comment == null) throw Error(`Could not find Comment by commentId: ${commentId}`);
      let user = await UserAccount.findByPk(myId);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${myId}`);
      return await CommentLike.create({ user_id: myId, comment_id: commentId });
    }
  },

  unfavoriteComment: {
    type: CommentLikeType,
    args: {
      myId: {
        type: new NonNull(Int)
      },
      commentId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { myId, commentId }) => {
      let comment = await Comment.findByPk(commentId);
      if (comment == null) throw Error(`Could not find Comment by commentId: ${commentId}`);
      let user = await UserAccount.findByPk(myId);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${myId}`);
      let like = await CommentLike.findOne({ where: { user_id: myId, comment_id: commentId }});
      if (like == null) throw Error(`Could not find CommentLike by userId: ${myId}, commentId: ${commentId}`);
      await like.destroy();
      return like;
    }
  },

  favoriteReply: {
    type: ReplyLikeType,
    args: {
      myId: {
        type: new NonNull(Int)
      },
      replyId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { myId, replyId }) => {
      let reply = await Reply.findByPk(replyId);
      if (reply == null) throw Error(`Could not find Reply by replyId: ${replyId}`);
      let user = await UserAccount.findByPk(myId);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${myId}`);
      return await ReplyLike.create({ user_id: myId, reply_id: replyId });
    }
  },

  unfavoriteReply: {
    type: ReplyLikeType,
    args: {
      myId: {
        type: new NonNull(Int)
      },
      replyId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { myId, replyId }) => {
      let reply = await Reply.findByPk(replyId);
      if (reply == null) throw Error(`Could not find Reply by replyId: ${replyId}`);
      let user = await UserAccount.findByPk(myId);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${myId}`);
      let like = await ReplyLike.findOne({ where: { user_id: myId, reply_id: replyId }});
      if (like == null) throw Error(`Could not find ReplyLike by userId: ${myId}, commentId: ${replyId}`);
      await like.destroy();
      return like;
    }
  }
};
