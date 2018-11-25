import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType, GraphQLString as String, } from 'graphql';
import { resolver } from 'graphql-sequelize';
import { Address, Store } from '../../models/index';
import StoreType from '../Store/StoreType';

Address.Store = Address.belongsTo(Store, { foreignKey: 'store_id' });

export default new ObjectType({
  name: 'Address',
  fields: () => ({
    id: { type: new NonNull(Int) },
    store: {
      type: StoreType,
      resolve: resolver(Address.Store),
    },
    address_first_line: { type: String },
    address_second_line: { type: String },
    address_street_number: { type: String },
    address_street_name: { type: String },
    google_url: { type: String },
  }),
});
