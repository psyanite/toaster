import { GraphQLObjectType as ObjectType } from 'graphql';
import StoreMutations from './StoreMutations';
import UserMutations from './UserMutations';
import UserRewardMutations from './UserRewardMutations';

const Mutation = new ObjectType({
  name: 'Meowtation',
  description: '🐈 Toaster Meowtations',
  fields: Object.assign({}, StoreMutations, UserMutations, UserRewardMutations),
});

export default Mutation;
