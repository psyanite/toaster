import { GraphQLObjectType as ObjectType } from 'graphql';
import StoreQueries from './StoreQueries';
import UserAccountQueries from './UserAccountQueries';
import UserLoginQueries from './UserLoginQueries';
import UserProfileQueries from './UserProfileQueries';
import PostQueries from './PostQueries';
import MeQueries from './MeQueries';
import RewardQueries from './RewardQueries';

export default new ObjectType({
  name: 'Meowry',
  fields: Object.assign(
    {},
    MeQueries,
    PostQueries,
    RewardQueries,
    StoreQueries,
    UserAccountQueries,
    UserLoginQueries,
    UserProfileQueries,
  ),
});
