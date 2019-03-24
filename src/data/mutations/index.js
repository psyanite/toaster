import { GraphQLObjectType as ObjectType } from 'graphql';
import StoreMutations from './StoreMutations';
import UserMutations from './UserMutations';
import UserRewardMutations from './UserRewardMutations';
import PostMutations from './PostMutations';

const Mutation = new ObjectType({
  name: 'Meowtation',
  description: '🐈 Toaster Meowtations',
  fields: Object.assign({}, PostMutations, StoreMutations, UserMutations, UserRewardMutations),
});

export default Mutation;
