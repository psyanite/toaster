import { GraphQLObjectType as ObjectType } from 'graphql';
import CommentQueries from './CommentQueries';
import CurateQueries from './CurateQueries';
import FeedQueries from './FeedQueries';
import MeQueries from './MeQueries';
import PostQueries from './PostQueries';
import RewardQueries from './RewardQueries';
import SearchQueries from './SearchQueries';
import StoreQueries from './StoreQueries';
import TaskQueries from './TaskQueries';
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
    CurateQueries,
    FeedQueries,
    MeQueries,
    PostQueries,
    RewardQueries,
    SearchQueries,
    StoreQueries,
    TaskQueries,
    UserAccountQueries,
    UserLoginQueries,
    UserProfileQueries,
    UserRewardQueries,
  ),
});
