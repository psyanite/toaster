import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';

export default new ObjectType({
  name: 'StoreHour',
  fields: () => ({
    id: { type: new NonNull(Int) },
    store_id: { type: new NonNull(Int) },
    order: { type: Int },
    dotw: { type: String },
    hours: { type: String },
  }),
});
