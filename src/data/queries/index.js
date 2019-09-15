import { GraphQLObjectType as ObjectType } from 'graphql';
import AdminQueries from './AdminQueries';
import CommentQueries from './CommentQueries';
import CurateQueries from './CurateQueries';
import FeedQueries from './FeedQueries';
import LocationQueries from './LocationQueries';
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
    AdminQueries,
    CommentQueries,
    CurateQueries,
    FeedQueries,
    LocationQueries,
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
