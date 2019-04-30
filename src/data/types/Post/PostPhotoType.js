import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Post, PostPhoto } from '../../models';
import PostType from './PostType';

PostPhoto.Post = PostPhoto.belongsTo(Post, { foreignKey: 'post_id' });

export default new ObjectType({
  name: 'PostPhoto',
  fields: () => ({
    id: { type: new NonNull(Int) },
    post: {
      type: PostType,
      resolve: resolver(PostPhoto.Post),
    },
    url: { type: String },
  }),
});
