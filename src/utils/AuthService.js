/* eslint-disable no-underscore-dangle */

import { UserAccount, UserLogin, UserProfile, UserClaim } from '../data/models';

const randomUsername = () => 'smoldoggo';

const randomProfilePicture = () => 'https://imgur.com/HYz307Q.jpg';

const fbProfilePicture = profileId =>
  `https://graph.facebook.com/${profileId}/picture?type=large`;

export const consumeFacebookAuth = async (accessToken, profile) => {
  const loginName = 'facebook';
  const claimType = 'urn:facebook:access_token';

  const accounts = await UserAccount.findAll({
    attributes: ['id', 'email'],
    include: [
      {
        attributes: ['name', 'key'],
        model: UserLogin,
        required: true,
        as: 'logins',
        where: { name: loginName, key: profile.id },
      },
      {
        attributes: ['username', 'display_name', 'gender', 'profile_picture'],
        model: UserProfile,
        required: true,
        as: 'profile',
      },
    ],
  });

  if (accounts.length) {
    // There exists an account linked to this Facebook account
    return accounts[0].get({ plain: true });
  }

  // No account linked to this Facebook account
  // Create a new one
  const user = await UserAccount.create(
    {
      email: profile.email,
      emailConfirmed: true,
      logins: [{ name: loginName, key: profile.id }],
      claims: [{ type: claimType, value: accessToken }],
      profile: {
        display_name: profile.displayName,
        username: profile.displayName,
        gender: profile.gender,
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

  return {
    id: user.id,
    email: user.email,
    profile: {
      username: user.profile.username,
      displayName: user.profile.displayName,
      gender: user.profile.gender,
      profilePicture: user.profile.profilePicture,
    },
  };
};
