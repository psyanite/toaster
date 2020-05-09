import {
  GraphQLInt as Int,
  GraphQLList as List,
  GraphQLNonNull as NonNull,
  GraphQLObjectType as ObjectType,
  GraphQLString as String,
} from 'graphql';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';
import { PointObject } from 'graphql-geojson';
import Utils from '../../utils/Utils';

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
  },
  coords: {
    type: Sequelize.GEOMETRY('POINT'),
  }
});

const LocationSearchResultType = new ObjectType({
  name: 'LocationSearchResult',
  fields: () => ({
    name: { type: String },
    description: { type: String },
    coords: {
      type: PointObject,
      resolve: Utils.resolveCoords,
    }
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
      return sequelize
        .query(`
            select *
            from cuisine_search
            where document @@ to_tsquery('english', unaccent(lower(:queryStr))) 
                  or unaccent(name) ~* unaccent(:queryStr)
            order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc
        `, {
          model: CuisineSearchResult,
          replacements: { queryStr: Utils.tsClean(query) }
        });
    }
  },

  locationsBySearch: {
    type: new List(LocationSearchResultType),
    args: {
      query: {
        type: new NonNull(String),
      },
      limit: {
        type: Int,
      }
    },
    resolve: async (_, { query, limit }) => {
      return sequelize
        .query(`
            select *
            from location_search
            where document @@ to_tsquery('english', unaccent(lower(:queryStr))) 
              or unaccent(name) ~* unaccent(:queryStr)
            order by ts_rank(document, to_tsquery('english', unaccent(lower(:queryStr)))) desc
        `, {
          model: LocationSearchResult,
          replacements: { queryStr: Utils.tsClean(query), limitStr: limit || 12 }
        });
    }
  },
};
