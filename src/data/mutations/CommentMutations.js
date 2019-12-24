import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { Comment, CommentLike, Post, Reply, ReplyLike, UserProfile } from '../models';
import CommentType from '../types/Post/CommentType';
import ReplyType from '../types/Post/ReplyType';
import ReplyLikeType from '../types/Post/ReplyLikeType';
import CommentLikeType from '../types/Post/CommentLikeType';
import FcmService from '../services/FcmService';

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

      const comment = await Comment.create({
        post_id: postId,
        body: body,
        commented_by: commentedBy
      });
      await post.increment('comment_count');

      // send notification to user or admin
      // var token;
      // if (post.posted_by) {
      //   const postedBy = await UserProfile.findByPk(post.posted_by);
      //   token = postedBy.fcm_token;
      // } else {
      //
      // }
      // if (token != null) FcmService.sendMessage()


      return comment;
    }
  },

  addStoreComment: {
    type: CommentType,
    args: {
      postId: {
        type: new NonNull(Int),
      },
      body: {
        type: String,
      },
      storeId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { postId, body, storeId }) => {
      let post = await Post.findByPk(postId);
      if (post == null) throw Error(`Could not find Post by postId: ${postId}`);
      const comment = await Comment.create({
        post_id: postId,
        body: body,
        commented_by_store: storeId
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
      if (comment.commented_by !== myId) throw Error(`You must be the owner of the comment to delete the comment`);
      await comment.destroy();
      await Post.decrement('comment_count', { where: { id: comment.post_id }});
      return comment;
    }
  },

  deleteStoreComment: {
    type: CommentType,
    args: {
      storeId: {
        type: new NonNull(Int)
      },
      commentId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, commentId }) => {
      let comment = await Comment.findByPk(commentId);
      if (comment == null) throw Error(`Could not find Comment by commentId: ${commentId}`);
      if (comment.commented_by_store !== storeId) throw Error(`You must be the owner of the comment to delete the comment`);
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
      return await Reply.create({
        comment_id: commentId,
        body: body,
        replied_by: repliedBy
      });
    }
  },

  addStoreReply: {
    type: ReplyType,
    args: {
      commentId: {
        type: new NonNull(Int),
      },
      body: {
        type: String,
      },
      storeId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { commentId, body, storeId }) => {
      return await Reply.create({
        comment_id: commentId,
        body: body,
        replied_by_store: storeId
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
      if (reply.replied_by !== myId) throw Error(`You must be the owner of the reply to delete the reply`);
      await reply.destroy();
      return reply;
    }
  },

  deleteStoreReply: {
    type: ReplyType,
    args: {
      storeId: {
        type: new NonNull(Int)
      },
      replyId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, replyId }) => {
      let reply = await Reply.findByPk(replyId);
      if (reply == null) throw Error(`Could not find Reply by replyId: ${replyId}`);
      if (reply.replied_by_store !== storeId) throw Error(`You must be the owner of the reply to delete the reply`);
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
      return await CommentLike.create({ user_id: myId, comment_id: commentId });
    }
  },

  favoriteCommentAsStore: {
    type: CommentLikeType,
    args: {
      storeId: {
        type: new NonNull(Int)
      },
      commentId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, commentId }) => {
      return await CommentLike.create({ store_id: storeId, comment_id: commentId });
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
      let like = await CommentLike.findOne({ where: { user_id: myId, comment_id: commentId }});
      if (like == null) throw Error(`Could not find CommentLike by userId: ${myId}, commentId: ${commentId}`);
      await like.destroy();
      return like;
    }
  },

  unfavoriteCommentAsStore: {
    type: CommentLikeType,
    args: {
      storeId: {
        type: new NonNull(Int)
      },
      commentId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, commentId }) => {
      let like = await CommentLike.findOne({ where: { store_id: storeId, comment_id: commentId }});
      if (like == null) throw Error(`Could not find CommentLike by storeId: ${storeId}, commentId: ${commentId}`);
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
      return await ReplyLike.create({ user_id: myId, reply_id: replyId });
    }
  },

  favoriteReplyAsStore: {
    type: ReplyLikeType,
    args: {
      storeId: {
        type: new NonNull(Int)
      },
      replyId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, replyId }) => {
      return await ReplyLike.create({ store_id: storeId, reply_id: replyId });
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
      let like = await ReplyLike.findOne({ where: { user_id: myId, reply_id: replyId }});
      if (like == null) throw Error(`Could not find ReplyLike by userId: ${myId}, commentId: ${replyId}`);
      await like.destroy();
      return like;
    }
  },

  unfavoriteReplyAsStore: {
    type: ReplyLikeType,
    args: {
      storeId: {
        type: new NonNull(Int)
      },
      replyId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, replyId }) => {
      let reply = await Reply.findByPk(replyId);
      if (reply == null) throw Error(`Could not find Reply by replyId: ${replyId}`);
      let like = await ReplyLike.findOne({ where: { store_id: storeId, reply_id: replyId }});
      if (like == null) throw Error(`Could not find ReplyLike by storeId: ${storeId}, commentId: ${replyId}`);
      await like.destroy();
      return like;
    }
  }
};
