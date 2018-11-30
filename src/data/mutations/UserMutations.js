/* eslint-disable camelcase */
import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';

import sequelize from '../sequelize';
import UserProfile from '../models/User/UserProfile';
import UserLogin from '../models/User/UserLogin';
import UserAccount from '../models/User/UserAccount';
import UserLoginType from '../types/User/UserLoginType';

const addUser = {
  type: UserLoginType,
  args: {
    username: {
      type: new NonNull(String),
    },
    display_name: {
      type: new NonNull(String),
    },
    email: {
      type: new NonNull(String),
    },
    profile_picture: {
      type: new NonNull(String),
    },
    social_id: {
      type: new NonNull(String),
    },
    social_type: {
      type: new NonNull(String),
    },
  },
  resolve: (
    value_,
    { username, display_name, email, profile_picture, social_id, social_type },
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
                user_account_id: userAccount.id,
                username,
                display_name,
                profile_picture,
              },
              { transaction: t },
            );
            return userAccount;
          })
          .then(userAccount =>
            UserLogin.create(
              {
                user_account_id: userAccount.id,
                social_type,
                social_id,
              },
              { transaction: t },
            ),
          ),
      )
      .then(result => result),
};

export default {
  addUser,
};
