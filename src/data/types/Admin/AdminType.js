import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLObjectType as ObjectType } from 'graphql';
import { GraphQLDateTime as DateTime } from 'graphql-iso-date';
import { resolver } from 'graphql-sequelize';

import { Admin, Store, UserProfile } from '../../models';
import StoreType from '../Store/StoreType';
import UserProfileType from '../User/UserProfileType';

Admin.UserProfile = Admin.hasOne(UserProfile);
Admin.Store = Admin.belongsTo(Store, { foreignKey: 'store_id' });

export default new ObjectType({
  name: 'Admin',
  fields: () => ({
    id: { type: new NonNull(Int) },
    profile: {
      type: UserProfileType,
      resolve: resolver(Admin.UserProfile),
    },
    store_id: { type: Int },
    store: {
      type: StoreType,
      resolve: resolver(Admin.Store),
    },
    created_at: { type: DateTime },
  }),
});
