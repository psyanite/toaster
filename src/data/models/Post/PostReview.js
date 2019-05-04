import Sequelize from 'sequelize';
import sequelize from '../../sequelize';

const ScoreEnum = Sequelize.ENUM('bad', 'okay', 'good');

const PostReview = sequelize.define('post_reviews', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  post_id: {
    type: Sequelize.INTEGER,
  },

  overall_score: {
    type: ScoreEnum,
  },

  taste_score: {
    type: ScoreEnum,
  },

  service_score: {
    type: ScoreEnum,
  },

  value_score: {
    type: ScoreEnum,
  },

  ambience_score: {
    type: ScoreEnum,
  },

  body: {
    type: Sequelize.TEXT,
  },
});

export default PostReview;
