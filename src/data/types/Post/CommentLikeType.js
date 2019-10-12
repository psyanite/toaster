import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType } from 'graphql';

export default new ObjectType({
  name: 'CommentLikeType',
  fields: () => ({
    id: { type: new NonNull(Int) },
    comment_id: { type: new NonNull(Int) },
    user_id: { type: Int },
    store_id: { type: Int },
  }),
});
