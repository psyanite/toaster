import { GraphQLObjectType as ObjectType } from 'graphql';
import CommentMutations from './CommentMutations';
import StoreMutations from './StoreMutations';
import UserMutations from './UserMutations';
import UserRewardMutations from './UserRewardMutations';
import PostMutations from './PostMutations';

const Mutation = new ObjectType({
  name: 'Meowtation',
  description: '🐈 Toaster Meowtations',
  fields: Object.assign({}, CommentMutations, PostMutations, StoreMutations, UserMutations, UserRewardMutations),
});

export default Mutation;
