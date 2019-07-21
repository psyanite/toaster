import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType } from 'graphql';

export default new ObjectType({
  name: 'ReplyLikeType',
  fields: () => ({
    user_id: { type: new NonNull(Int) },
    reply_id: { type: new NonNull(Int) },
  }),
});
