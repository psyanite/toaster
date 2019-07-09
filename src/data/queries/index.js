import { GraphQLObjectType as ObjectType } from 'graphql';
import CommentQueries from './CommentQueries';
import MeQueries from './MeQueries';
import PostQueries from './PostQueries';
import RewardQueries from './RewardQueries';
import SearchQueries from './SearchQueries';
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
    CommentQueries,
    MeQueries,
    PostQueries,
    RewardQueries,
    SearchQueries,
    StoreQueries,
    UserAccountQueries,
    UserLoginQueries,
    UserProfileQueries,
    UserRewardQueries,
  ),
});
