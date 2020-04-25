import { QueryTypes } from 'sequelize';
import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import bcrypt from 'bcrypt';

import { Admin, UserProfile } from '../models';
import AdminType from '../types/Admin/AdminType';
import UserProfileType from '../types/User/UserProfileType';
import FcmService from '../services/FcmService';
import Utils from '../../utils/Utils';
import sequelize from '../sequelize';

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


  /** Test Queries **/
  cooper: {
    type: Int,
    resolve: async () => {
      const result = await sequelize
        .query(`
          select reltuples
          from pg_catalog.pg_class
          where relname = 'stores'
        `, { type: QueryTypes.SELECT });

      try {
        return parseInt(result[0]['reltuples'], 10);
      } catch (e) {
        const msg = `Failed response: ${JSON.stringify(result)}`;
        Utils.error(() => {
          console.error(msg);
          console.error(e);
        });
        return msg;
      }
    },
  },

  testNotification: {
    type: String,
    resolve: async () => {
      const user = await UserProfile.findByPk(2);
      try {
        return FcmService.notifyPost(FcmService.fcm.burntoast, {
          token: user.fcm_token,
          title: 'perrylicious',
          body: 'Replied to your comment: Can\'t wait to come here next Friday!!! 🥩',
          postId: '134',
          flashReply: '92',
        });
      } catch (e) {
        Utils.error(() => console.error(e, e.stack));
      }
    },
  },
};
