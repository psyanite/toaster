import { GraphQLObjectType as ObjectType } from 'graphql';
import SearchQueries from './SearchQueries';
import MeQueries from './MeQueries';
import PostQueries from './PostQueries';
import RewardQueries from './RewardQueries';
import StoreQueries from './StoreQueries';
import UserAccountQueries from './UserAccountQueries';
import UserLoginQueries from './UserLoginQueries';
import UserProfileQueries from './UserProfileQueries';
import UserRewardQueries from './UserRewardQueries';

export default new ObjectType({
  name: 'Meowry',
  description: '🐈 Toaster Meowries',
  fields: Object.assign(
    {},
    SearchQueries,
    MeQueries,
    PostQueries,
    RewardQueries,
    StoreQueries,
    UserAccountQueries,
    UserLoginQueries,
    UserProfileQueries,
    UserRewardQueries,
  ),
});
