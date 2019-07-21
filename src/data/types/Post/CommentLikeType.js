import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType } from 'graphql';

export default new ObjectType({
  name: 'CommentLikeType',
  fields: () => ({
    user_id: { type: new NonNull(Int) },
    comment_id: { type: new NonNull(Int) },
  }),
});
