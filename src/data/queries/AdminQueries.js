/* eslint-disable no-param-reassign */
import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { Admin } from '../models';
import AdminType from '../types/Admin/AdminType';
import bcrypt from 'bcrypt';

export default {
  findAdminById: {
    type: AdminType,
    args: {
      id: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { id }) => {
      return Admin.findByPk(id)
    }
  },

  findAdminByUsername: {
    type: AdminType,
    args: {
      username: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { username }) => {
      return Admin.findOne({ where: { username } });
    }
  },

  adminLogin: {
    type: AdminType,
    args: {
      username: {
        type: new NonNull(String),
      },
      password: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { username, password }) => {
      const admin = await Admin.findOne({ where: { username } });
      if (admin == null) throw Error(`Could not find Admin by username: ${username}`);
      const match = await bcrypt.compare(password, admin.hash);
      if (!match) throw Error(`Incorrect login details`);
      return admin;
    }
  },
};
