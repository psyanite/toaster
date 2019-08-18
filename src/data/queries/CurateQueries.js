/* eslint-disable no-param-reassign */
import TagType from '../types/Store/TagType';
import { GraphQLString as String, GraphQLNonNull as NonNull } from 'graphql';
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
