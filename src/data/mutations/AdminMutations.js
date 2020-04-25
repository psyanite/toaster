import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import bcrypt from 'bcrypt';
import sequelize from '../sequelize';

import { Admin, UserAccount, UserProfile } from '../models';
import UserProfileType from '../types/User/UserProfileType';

const SaltRounds = 10;

export default {

  addAdmin: {
    type: UserProfileType,
    args: {
      email: {
        type: new NonNull(String),
      },
      username: {
        type: new NonNull(String),
      },
      password: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { email, username, password }) => {
      return sequelize.transaction(async t => {
        const user = await UserAccount.create({ email }, { transaction: t });
        const hash = await bcrypt.hash(password, SaltRounds);
        const admin = await Admin.create({ user_id: user.id, hash }, { transaction: t });

        return UserProfile.create({
            user_id: user.id,
            username,
            admin_id: admin.id,
          }, { transaction: t },
        );
      });
    }
  },

  setAdminPassword: {
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
      const admin = await Admin.findOne({
        include: [{
          model: UserProfile,
          where: { username: username }
        }]
      });

      if (admin == null) throw Error(`Could not find Admin by username: ${username}`);
      const hash = await bcrypt.hash(password, SaltRounds);
      await admin.update({ hash: hash });
      return admin;
    }
  }
};
