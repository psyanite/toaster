/**
 * React Starter Kit (https://www.reactstarterkit.com/)
 *
 * Copyright © 2014-present Kriasoft, LLC. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE.txt file in the root directory of this source tree.
 */

/**
 * Passport.js reference implementation.
 * The database schema used in this sample is available at
 * https://github.com/membership/membership.db/tree/master/postgres
 */

import passport from 'passport';
import { Strategy as FacebookStrategy } from 'passport-facebook';
import { UserAccount, UserLogin, UserClaim, UserProfile } from './data/models';
import config from './config';

/**
 * Sign in with Facebook.
 */
passport.use(
  new FacebookStrategy(
    {
      clientID: config.auth.facebook.id,
      clientSecret: config.auth.facebook.secret,
      callbackURL: '/login/facebook/return',
      profileFields: ['displayName', 'name', 'email'],
      passReqToCallback: true,
    },
    (req, accessToken, refreshToken, profile, done) => {
      /* eslint-disable no-underscore-dangle */
      const loginName = 'facebook';
      const claimType = 'urn:facebook:access_token';
      const fooBar = async () => {
        /**
         * Check if there is an account linked with this Facebook account
         */
        if (req.user) {
          const userLogin = await UserLogin.findOne({
            attributes: ['user_account_id', 'name', 'key'],
            where: { name: loginName, key: profile.id },
          });
          if (userLogin) {
            // There exists an account linked to this Facebook account
            const account = await UserAccount.findOne({
              attributes: ['id', 'email'],
              where: { id: userLogin.user_account_id },
            });
            done(null, {
              id: account.id,
              email: account.email,
            });
          } else {
            const user = await UserAccount.create(
              {
                email: profile._json.email,
                emailConfirmed: true,
                logins: [{ name: loginName, key: profile.id }],
                claims: [{ type: claimType, value: accessToken }],
                profile: {
                  display_name: profile.displayName,
                  username: profile.displayName,
                  gender: profile._json.gender,
                  profile_picture: `https://graph.facebook.com/${
                    profile.id
                  }/picture?type=large`,
                },
              },
              {
                include: [
                  { model: UserClaim, as: 'claims' },
                  { model: UserLogin, as: 'logins' },
                  { model: UserProfile, as: 'profile' },
                ],
              },
            );
            done(null, {
              id: user.id,
              email: user.email,
            });
          }
        } else {
          const accounts = await UserAccount.findAll({
            attributes: ['id', 'email'],
            where: { name: loginName, key: profile.id },
            include: [
              {
                attributes: ['name', 'key'],
                model: UserLogin,
                required: true,
              },
            ],
          });
          if (accounts.length) {
            const account = accounts[0].get({ plain: true });
            done(null, {
              id: account.id,
              email: account.email,
            });
          } else {
            let account = await UserAccount.findOne({
              attributes: ['id', 'email'],
              where: { email: profile._json.email },
            });
            if (account) {
              done(null, {
                id: account.id,
                email: account.email,
              });
            } else {
              account = await UserAccount.create(
                {
                  email: profile._json.email,
                  emailConfirmed: true,
                  logins: [{ name: loginName, key: profile.id }],
                  claims: [{ type: claimType, value: accessToken }],
                  profile: {
                    display_name: profile.displayName,
                    username: profile.displayName,
                    gender: profile._json.gender,
                    profile_picture: `https://graph.facebook.com/${
                      profile.id
                    }/picture?type=large`,
                  },
                },
                {
                  include: [
                    { model: UserClaim, as: 'claims' },
                    { model: UserLogin, as: 'logins' },
                    { model: UserProfile, as: 'profile' },
                  ],
                },
              );
              done(null, {
                id: account.id,
                email: account.email,
              });
            }
          }
        }
      };

      fooBar().catch(done);
    },
  ),
);

export default passport;
