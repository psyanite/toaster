import sequelize from '../sequelize';

import UserAccount from './User/UserAccount';
import UserClaim from './User/UserClaim';
import UserFollow from './User/UserFollow';
import UserLogin from './User/UserLogin';
import UserProfile from './User/UserProfile';
import UserReward from './User/UserReward';

import Store from './Store/Store';
import StoreFollow from './Store/StoreFollow';
import StoreGroup from './Store/StoreGroup';
import Rating from './Store/Rating';
import Cuisine from './Store/Cuisine';

import Country from './Location/Country';
import District from './Location/District';
import City from './Location/City';
import Suburb from './Location/Suburb';
import Location from './Location/Location';
import Address from './Location/Address';

import Post from './Post/Post';
import PostPhoto from './Post/PostPhoto';
import PostReview from './Post/PostReview';
import Comment from './Post/Comment';
import CommentLike from './Post/CommentLike';
import Reply from './Post/Reply';
import ReplyLike from './Post/ReplyLike';

import Reward from './Reward/Reward';

function sync(...args) {
  return sequelize.sync(...args);
}

export default { sync };

export {
  UserAccount,
  UserClaim,
  UserFollow,
  UserLogin,
  UserProfile,
  UserReward,
  Store,
  StoreFollow,
  StoreGroup,
  Rating,
  Cuisine,
  Country,
  District,
  City,
  Suburb,
  Location,
  Address,
  Post,
  PostPhoto,
  PostReview,
  Comment,
  CommentLike,
  Reply,
  ReplyLike,
  Reward,
};
