/* eslint-disable no-underscore-dangle */

import { UserAccount, UserLogin, UserProfile, UserClaim } from '../data/models';

const randomUsername = () => 'smoldoggo';

const randomProfilePicture = () => 'https://imgur.com/HYz307Q.jpg';

const fbProfilePicture = profileId =>
  `https://graph.facebook.com/${profileId}/picture?type=large`;

export const consumeFacebookAuth = async (accessToken, fbProfile) => {
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
        where: { name: loginName, key: fbProfile.id },
      },
      {
        attributes: ['username', 'display_name', 'gender', 'profile_picture'],
        model: UserProfile,
        required: true,
        as: 'profile',
      },
    ],
  });

  console.log('AuthServices.findAllByLoginNameAndFbProfileId');
  console.log(accounts);

  if (accounts.length) {
    console.log('It is going to return:');
    console.log(accounts[0].get({ plain: true }));
    // There exists an account linked to this Facebook account
    return accounts[0].get({ plain: true });
  }

  console.log('Did not match fb login to an existing account');
  console.log('Now creating new account');
  console.log(fbProfile);

  // No account linked to this Facebook account
  // Create a new one
  const user = await UserAccount.create(
    {
      email: fbProfile.email,
      emailConfirmed: true,
      logins: [{ name: loginName, key: fbProfile.id }],
      claims: [{ type: claimType, value: accessToken }],
      profile: {
        display_name: fbProfile.name,
        username: randomUsername(),
        gender: fbProfile.gender,
        profile_picture: randomProfilePicture(),
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

  console.log('AuthServices created a new user');
  console.log(user);

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
