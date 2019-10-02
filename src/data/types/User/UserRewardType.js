import { GraphQLObjectType as ObjectType, GraphQLString as String, GraphQLInt as Int } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { Reward, UserAccount, UserReward } from '../../models';
import UserAccountType from './UserAccountType';
import RewardType from '../Reward/RewardType';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';

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
    user_id: { type: Int },
    reward_id: { type: Int },
    reward: {
      type: RewardType,
      resolve: resolver(UserReward.Reward),
    },
    unique_code: { type: String },
    last_redeemed_at: { type: DateTime },
    redeemed_count: { type: Int },
  }),
});
