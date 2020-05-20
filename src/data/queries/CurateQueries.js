import TagType from '../types/Store/TagType';
import { GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import CurateService from '../services/CurateService';

export default {
  curatedByTag: {
    type: TagType,
    args: {
      tag: {
        type: new NonNull(String),
      },
    },
    resolve: (_, { tag }) => {
      return CurateService.getCurate(tag);
    }
  },
};
