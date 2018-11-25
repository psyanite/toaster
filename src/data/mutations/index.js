import { GraphQLObjectType as ObjectType } from 'graphql';
import StoreMutations from './StoreMutations';
import UserMutations from './UserMutations';

const Mutation = new ObjectType({
  name: 'Meowtation',
  description: 'Meowtation',
  fields: Object.assign({}, StoreMutations, UserMutations),
});

export default Mutation;
