import {
  GraphQLEnumType as EnumType, GraphQLInt as Int, GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql'
import { resolver } from 'graphql-sequelize'
import { Post, PostReview } from '../../models'
import PostType from './PostType'

PostReview.Post = PostReview.belongsTo(Post, { foreignKey: 'post_id' })

const ScoreType = new EnumType({
  name: 'ScoreType',
  values: {
    bad: { value: 'bad' },
    okay: { value: 'okay' },
    good: { value: 'good' },
  },
})

export default new ObjectType({
  name: 'PostReview',
  fields: () => ({
    id: { type: new NonNull(Int) },
    post: {
      type: PostType,
      resolve: resolver(PostReview.Post),
    },
    overall_score: { type: ScoreType },
    taste_score: { type: ScoreType },
    service_score: { type: ScoreType },
    value_score: { type: ScoreType },
    ambience_score: { type: ScoreType },
    body: { type: String },
  }),
})
