/* eslint-disable no-param-reassign */
import { GraphQLList as List, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';

const CuisineSearchResult = sequelize.define('cuisines_search', {
  name: {
    type: Sequelize.STRING,
  },
});

const CuisineSearchResultType = new ObjectType({
  name: 'CuisineSearchResult',
  fields: () => ({
    name: { type: String },
  }),
});

const LocationSearchResult = sequelize.define('location_search', {
  name: {
    type: Sequelize.STRING,
  },
  description: {
    type: Sequelize.STRING,
  }
});

const LocationSearchResultType = new ObjectType({
  name: 'LocationSearchResult',
  fields: () => ({
    name: { type: String },
    description: { type: String },
  }),
});

export default {
  cuisinesBySearch: {
    type: new List(CuisineSearchResultType),
    args: {
      query: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { query }) => {
      const clean = query.replace(/\s+/g, ' | ');
      return await sequelize
        .query(`
            select *
            from cuisine_search
            where document @@ to_tsquery('english', :queryStr) or unaccent(lower(name)) like unaccent(lower(:likeStr))
            order by ts_rank(document, to_tsquery('english', :queryStr)) desc
        `, {
          model: CuisineSearchResult,
          replacements: { queryStr: clean, likeStr: `%${clean}%` }
        });
    }
  },

  locationsBySearch: {
    type: new List(LocationSearchResultType),
    args: {
      query: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { query }) => {
      const clean = query.replace(/\s+/g, ' | ');
      return await sequelize
        .query(`
            select *
            from location_search
            where document @@ to_tsquery('english', :queryStr) or lower(name) like lower(:likeStr)
            order by ts_rank(document, to_tsquery('english', :queryStr)) desc
        `, {
          model: LocationSearchResult,
          replacements: { queryStr: clean, likeStr: `%${clean}%` }
        });
    }
  },
};
