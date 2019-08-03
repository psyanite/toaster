/* eslint-disable no-param-reassign */
import {
  GraphQLList as List,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
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
        type: String,
      },
    },
    resolve: async (_, { query }) => {
      const clean = query.replace(/\s+/g, ' | ');
      return await sequelize
        .query(`
          select *
          from cuisine_search
          where document @@ to_tsquery('english', :querystring)
            or unaccent(lower(name)) like unaccent(lower(:likestring))
          order by ts_rank(document, to_tsquery('english', :querystring)) desc
        `, {
          model: CuisineSearchResult,
          replacements: { queryString: clean, likeString: `%${clean}%` }
        });
    }
  },

  locationsBySearch: {
    type: new List(LocationSearchResultType),
    args: {
      query: {
        type: String,
      },
    },
    resolve: async (_, { query }) => {
      const clean = query.replace(/\s+/g, ' | ');
      return await sequelize
        .query(`
          select *
          from location_search
          where document @@ to_tsquery('english', :querystring)
            or lower(name) like lower(:likestring)
          order by ts_rank(document, to_tsquery('english', :querystring)) desc
        `, {
          model: LocationSearchResult,
          replacements: { queryString: clean, likeString: `%${clean}%` }
        });
    }
  },
};
