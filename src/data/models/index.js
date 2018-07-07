import sequelize from '../sequelize';

import UserAccount from './User/UserAccount';
import UserClaim from './User/UserClaim';
import UserLogin from './User/UserLogin';
import UserProfile from './User/UserProfile';

import Store from './Store';

import Cuisine from './Cuisine';

import Country from './Location/Country';
import District from './Location/District';
import City from './Location/City';
import Suburb from './Location/Suburb';
import Location from './Location/Location';
import Address from './Location/Address';

import Post from './Post/Post';
import PostPhoto from './Post/PostPhoto';
import PostReview from './Post/PostReview';

function sync(...args) {
  return sequelize.sync(...args);
}

export default { sync };

export {
  UserAccount,
  UserClaim,
  UserLogin,
  UserProfile,
  Store,
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
};
