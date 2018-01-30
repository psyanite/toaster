import { GraphQLSchema as Schema } from 'graphql';
import Query from './queries';
import Mutation from './mutations';

const schema = new Schema({
  query: Query,
  mutation: Mutation,
});

export default schema;
