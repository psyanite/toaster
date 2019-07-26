import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import sequelize from '../sequelize';
import UserProfile from '../models/User/UserProfile';
import Reward from '../models/Reward/Reward';
import Store from '../models/Store/Store';
import Post from '../models/Post/Post';
import UserLogin from '../models/User/UserLogin';
import UserAccount from '../models/User/UserAccount';
import UserLoginType from '../types/User/UserLoginType';
import UserAccountType from '../types/User/UserAccountType';

export default {
  addUser: {
    type: UserLoginType,
    args: {
      username: {
        type: new NonNull(String),
      },
      displayName: {
        type: new NonNull(String),
      },
      email: {
        type: new NonNull(String),
      },
      profilePicture: {
        type: new NonNull(String),
      },
      socialId: {
        type: new NonNull(String),
      },
      socialType: {
        type: new NonNull(String),
      },
    },
    resolve: (
      value_,
      { username, displayName, email, profilePicture, socialId, socialType },
    ) =>
      sequelize
        .transaction(t =>
          UserAccount.create(
            {
              email,
            },
            { transaction: t },
          )
            .then(userAccount => {
              UserProfile.create(
                {
                  user_id: userAccount.id,
                  username,
                  preferred_name: displayName,
                  profile_picture: profilePicture,
                },
                { transaction: t },
              );
              return userAccount;
            })
            .then(userAccount =>
              UserLogin.create(
                {
                  social_type: socialType,
                  social_id: socialId,
                  user_id: userAccount.id,
                },
                { transaction: t },
              ),
            ),
        )
        .then(result => result),
  },
  favoriteReward: {
    type: UserAccountType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      rewardId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, rewardId }) => {
      let user = await UserAccount.findByPk(userId, { include: ['favoriteRewards'] });
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const reward = await Reward.findByPk(rewardId);
      if (reward == null)  throw Error(`Could not find Reward by rewardId: ${rewardId}`);
      await user.addFavoriteRewards(reward);
      user = await UserAccount.findByPk(userId, { include: ['favoriteRewards'] });
      return user;
    }
  },
  unfavoriteReward: {
    type: UserAccountType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      rewardId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, rewardId }) => {
      let user = await UserAccount.findByPk(userId, { include: ['favoriteRewards'] });
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const reward = await Reward.findByPk(rewardId);
      if (reward == null)  throw Error(`Could not find Store by rewardId: ${rewardId}`);
      await user.removeFavoriteRewards(reward);
      user = await UserAccount.findByPk(userId, { include: ['favoriteRewards'] });
      return user;
    }
  },
  favoriteStore: {
    type: UserAccountType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      storeId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, storeId }) => {
      let user = await UserAccount.findByPk(userId, { include: ['favoriteStores'] });
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const store = await Store.findByPk(storeId);
      if (store == null)  throw Error(`Could not find Store by storeId: ${storeId}`);
      await user.addFavoriteStores(store);
      user = await UserAccount.findByPk(userId, { include: ['favoriteStores'] });
      return user;
    }
  },
  unfavoriteStore: {
    type: UserAccountType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      storeId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, storeId }) => {
      let user = await UserAccount.findByPk(userId, { include: ['favoriteStores'] });
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const store = await Store.findByPk(storeId);
      if (store == null)  throw Error(`Could not find Store by storeId: ${storeId}`);
      await user.removeFavoriteStores(store);
      user = await UserAccount.findByPk(userId, { include: ['favoriteStores'] });
      return user;
    }
  },
  favoritePost: {
    type: UserAccountType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      postId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, postId }) => {
      let user = await UserAccount.findByPk(userId, { include: ['favoritePosts'] });
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const post = await Post.findByPk(postId);
      if (post == null)  throw Error(`Could not find Post by postId: ${postId}`);
      await user.addFavoritePosts(post);
      user = await UserAccount.findByPk(userId, { include: ['favoritePosts'] });
      await post.increment('like_count');
      return user;
    }
  },
  unfavoritePost: {
    type: UserAccountType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      postId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, postId }) => {
      let user = await UserAccount.findByPk(userId, { include: ['favoritePosts'] });
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const post = await Post.findByPk(postId);
      if (post == null)  throw Error(`Could not find Post by postId: ${postId}`);
      await user.removeFavoritePosts(post);
      user = await UserAccount.findByPk(userId, { include: ['favoritePosts'] });
      await post.decrement('like_count');
      return user;
    }
  },
};
