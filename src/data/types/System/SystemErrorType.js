import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';

export default new ObjectType({
  name: 'SystemError',
  fields: () => ({
    id: { type: new NonNull(Int) },
    error_type: { type: String },
    description: { type: String },
    occurred_at: { type: DateTime },
  }),
});
