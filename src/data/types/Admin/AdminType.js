import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';

import { Admin } from '../../models';
import Store from '../../models/Store/Store';
import StoreType from '../Store/StoreType';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';

Admin.Store = Admin.belongsTo(Store, {
  foreignKey: 'store_id',
  as: 'store',
});

export default new ObjectType({
  name: 'Admin',
  fields: () => ({
    id: { type: new NonNull(Int) },
    username: { type: String },
    store: {
      type: StoreType,
      resolve: resolver(Admin.Store),
    },
    created_at: { type: DateTime },
  }),
});
