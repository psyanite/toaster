import { GraphQLBoolean as Boolean, GraphQLObjectType as ObjectType, GraphQLString as String } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { Reward, UserAccount, UserReward } from '../../models';
import UserAccountType from './UserAccountType';
import RewardType from '../Reward/RewardType';

UserReward.UserAccount = UserReward.belongsTo(UserAccount, {
  foreignKey: 'user_id',
});

UserReward.Reward = UserReward.belongsTo(Reward, {
  foreignKey: 'reward_id',
});

export default new ObjectType({
  name: 'UserReward',
  fields: () => ({
    user_account: {
      type: UserAccountType,
      resolve: resolver(UserReward.UserAccount),
    },
    reward: {
      type: RewardType,
      resolve: resolver(UserReward.Reward),
    },
    unique_code: { type: String },
    is_redeemed: { type: Boolean },
  }),
});
