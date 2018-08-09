/**
 * Passport.js reference implementation.
 * The database schema used in this sample is available at
 * https://github.com/membership/membership.db/tree/master/postgres
 */
/* eslint-disable no-underscore-dangle */

import passport from 'passport';
import { Strategy as FacebookStrategy } from 'passport-facebook';
import config from './config';
import { UserAccount, UserClaim, UserLogin, UserProfile } from './data/models';
import * as AuthService from './utils/AuthService';

/**
 * Sign in with Facebook
 */
passport.use(
  new FacebookStrategy(
    {
      clientID: config.auth.facebook.id,
      clientSecret: config.auth.facebook.secret,
      callbackURL: '/login/facebook/return',
      profileFields: ['displayName', 'name', 'email'],
      passReqToCallback: true,
      enableProof: true,
    },
    (req, accessToken, refreshToken, profile, done) => {
      /* eslint-disable no-underscore-dangle */

      const fooBar = async () => {
        /**
         * Check if there is an account linked with this Facebook account
         */
        if (req.user) {
          const response = await AuthService.consumeFacebookAuth(
            accessToken,
            profile,
          );
          done(null, response);
        }
      };

      fooBar().catch(done);
    },
  ),
);

export default passport;
