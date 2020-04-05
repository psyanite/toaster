import { GraphQLInt as Int, GraphQLList as List, GraphQLNonNull as NonNull, GraphQLString as String } from 'graphql';
import { Suburb } from '../models';
import SuburbType from '../types/Location/SuburbType';
import Sequelize from 'sequelize';
import sequelize from '../sequelize';

const Op = Sequelize.Op;

export default {
  suburbByName: {
    type: SuburbType,
    args: {
      name: {
        type: new NonNull(String),
      },
    },
    resolve: async (_, { name }) => {
      return Suburb.findOne({ where: { name: name } });
    }
  },

  suburbsByQuery: {
    type: new List(SuburbType),
    args: {
      name: {
        type: String,
      },
      postcode: {
        type: Int,
      }
    },
    resolve: async (_, { name, postcode }) => {
      if (!name && !postcode) return null;
      const nameArg = name ? { name: { [Op.like]: `%${name.replace(/\s+/g, ' | ')}%` } } : {};
      const postcodeArg = postcode ? { postcode: postcode } : {};
      return Suburb.findAll({ where: { ...nameArg, ...postcodeArg }, limit: 12 })
    }
  },

  suburbsBySearch: {
    type: new List(SuburbType),
    args: {
      query: {
        type: new NonNull(String),
      },
      limit: {
        type: Int,
      }
    },
    resolve: async (_, { query, limit }) => {
      const suburbs = await sequelize
        .query(`
            select *
            from suburbs
            where document @@ to_tsquery('english', :queryStr) or lower(name) like lower(:likeStr)
            order by ts_rank(document, to_tsquery('english', :queryStr)) desc
            limit :limitStr
        `, {
          model: Suburb,
          replacements: { queryStr: Utils.tsClean(query), likeStr: `%${query}%`, limitStr: limit || 12 }
        });
      return Suburb.findAll({ where: { id: { [Op.in]: suburbs.map(s => s.id) } } });
    }
  },
}
