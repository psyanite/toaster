import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType } from 'graphql';

export default new ObjectType({
  name: 'ReplyLikeType',
  fields: () => ({
    id: { type: new NonNull(Int) },
    reply_id: { type: new NonNull(Int) },
    user_id: { type: Int },
    store_id: { type: Int },
  }),
});
