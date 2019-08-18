import {
  GraphQLInt as Int,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
} from 'graphql';
import { Rating, Store } from '../../models';

Rating.Store = Rating.belongsTo(Store, {
  through: 'store_ratings_cache',
  foreignKey: 'store_id',
});

export default new ObjectType({
  name: 'Rating',
  fields: () => ({
    store_id: { type: new NonNull(Int) },
    heart_ratings: { type: Int },
    okay_ratings: { type: Int },
    burnt_ratings: { type: Int },
  }),
});
