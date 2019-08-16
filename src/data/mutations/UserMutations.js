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
import UserProfileType from '../types/User/UserProfileType';
import UserFollowType from '../types/User/UserFollowType';
import UserFollow from '../models/User/UserFollow';
import GeneralUtils from '../../utils/GeneralUtils';

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
                  code: GeneralUtils.generateCode(),
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

  addUserFollower: {
    type: UserFollowType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      followerId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, followerId }) => {
      const user = await UserAccount.findByPk(userId);
      if (user == null) throw Error(`Could not find UserAccount by userId: ${userId}`);
      const follower = await UserAccount.findByPk(followerId);
      if (follower == null) throw Error(`Could not find UserAccount by followerId: ${followerId}`);
      const exist = await UserFollow.findOne({ where: { user_id: userId, follower_id: followerId } });
      if (exist != null) throw Error(`Follow already exists for userId: ${userId}, followerId: ${followerId}`);
      const follow = await UserFollow.create({ user_id: userId, follower_id: followerId });
      if (follow != null) await UserProfile.increment('follower_count', { where: { user_id: userId } });
      return follow;
    }
  },

  deleteUserFollower: {
    type: UserFollowType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      followerId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId, followerId }) => {
      const exist = await UserFollow.findOne({ where: { user_id: userId, follower_id: followerId } });
      if (exist == null) throw Error(`Could not find UserFollow for userId: ${userId}, followerId: ${followerId}`);
      await exist.destroy();
      await UserProfile.decrement('follower_count', { where: { user_id: userId } });
      return exist;
    }
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
      if (reward == null) throw Error(`Could not find Reward by rewardId: ${rewardId}`);
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
      if (reward == null) throw Error(`Could not find Store by rewardId: ${rewardId}`);
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
      if (store == null) throw Error(`Could not find Store by storeId: ${storeId}`);
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
      if (store == null) throw Error(`Could not find Store by storeId: ${storeId}`);
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
      if (post == null) throw Error(`Could not find Post by postId: ${postId}`);
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
      if (post == null) throw Error(`Could not find Post by postId: ${postId}`);
      await user.removeFavoritePosts(post);
      user = await UserAccount.findByPk(userId, { include: ['favoritePosts'] });
      await post.decrement('like_count');
      return user;
    }
  },

  setTagline: {
    type: UserProfileType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      tagline: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { userId, tagline }) => {
      let profile = await UserProfile.findByPk(userId);
      if (profile == null) throw Error(`Could not find UserProfile by userId: ${userId}`);
      await profile.update({ tagline: tagline });
      return profile;
    }
  },

  deleteTagline: {
    type: UserProfileType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { userId }) => {
      let profile = await UserProfile.findByPk(userId);
      if (profile == null) throw Error(`Could not find UserProfile by userId: ${userId}`);
      await profile.update({ tagline: null });
      return profile;
    }
  },

  setProfilePicture: {
    type: UserProfileType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      picture: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { userId, picture }) => {
      let profile = await UserProfile.findByPk(userId);
      if (profile == null) throw Error(`Could not find UserProfile by userId: ${userId}`);
      await profile.update({ profile_picture: picture });
      return profile;
    }
  },

  setPreferredName: {
    type: UserProfileType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      name: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { userId, name }) => {
      let profile = await UserProfile.findByPk(userId);
      if (profile == null) throw Error(`Could not find UserProfile by userId: ${userId}`);
      await profile.update({ preferred_name: name });
      return profile;
    }
  },

  setUsername: {
    type: UserProfileType,
    args: {
      userId: {
        type: new NonNull(Int),
      },
      name: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { userId, name }) => {
      let profile = await UserProfile.findByPk(userId);
      if (profile == null) throw Error(`Could not find UserProfile by userId: ${userId}`);
      await profile.update({ username: name });
      return profile;
    }
  },
};
