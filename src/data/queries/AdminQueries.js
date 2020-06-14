import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import bcrypt from 'bcrypt';

import { Admin, UserProfile } from '../models';
import AdminType from '../types/Admin/AdminType';
import UserProfileType from '../types/User/UserProfileType';

export default {
  adminById: {
    type: AdminType,
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { id }) => {
      return Admin.findByPk(id);
    }
  },

  adminLogin: {
    type: UserProfileType,
    args: {
      username: {
        type: new NonNull(String),
      },
      password: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { username, password }) => {
      const user = await UserProfile.findOne({ where: { username }});
      if (user == null) throw Error(`Could not find Admin by username: ${username}`);

      const admin = await Admin.findByPk(user.admin_id);
      if (admin == null) throw Error(`Could not find Admin by username: ${username}`);

      const match = await bcrypt.compare(password, admin.hash);
      if (!match) throw Error(`Incorrect login details`);
      return user;
    }
  },
};
