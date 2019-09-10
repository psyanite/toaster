import { GraphQLInt as Int, GraphQLNonNull as NonNull, GraphQLString as String, GraphQLFloat as Float } from 'graphql';

import sequelize from '../sequelize';

import WhereService from '../services/WhereService';
import CuisineService from '../services/CuisineService';

import { Store, StoreAddress, StoreCuisine, StoreFollow, StoreHour, UserAccount } from '../models';
import StoreType from '../types/Store/StoreType';
import StoreFollowType from '../types/Store/StoreFollowType';

export default {
  upsertStore: {
    type: StoreType,
    args: {
      zId: {
        type: new NonNull(String),
      },
      zUrl: {
        type: new NonNull(String),
      },
      name: {
        type: new NonNull(String),
      },
      phoneCountry: {
        type: new NonNull(String),
      },
      phoneNumber: {
        type: new NonNull(String),
      },
      coverImage: {
        type: new NonNull(String),
      },
      addressFirstLine: {
        type: String,
      },
      addressSecondLine: {
        type: String,
      },
      addressStreetNumber: {
        type: String,
      },
      addressStreetName: {
        type: String,
      },
      googleUrl: {
        type: String,
      },
      cuisines: {
        type: new NonNull(String),
      },
      location: {
        type: String,
      },
      suburb: {
        type: new NonNull(String),
      },
      city: {
        type: new NonNull(String),
      },
      lat: {
        type: new NonNull(Float)
      },
      lng: {
        type: new NonNull(Float)
      },
      moreInfo: {
        type: String,
      },
      avgCost: {
        type: new NonNull(Int),
      },
      hours: {
        type: new NonNull(String),
      }
    },
    resolve: async (_, {
      zId, zUrl, name, phoneCountry, phoneNumber, coverImage,
      addressFirstLine, addressSecondLine, addressStreetNumber, addressStreetName, googleUrl,
      cuisines, location, suburb, city,
      lat, lng,
      moreInfo, avgCost, hours
    }) => {
      const process = async (t) => {
        // const exist = await Store.findOne({ where: { z_id: z_id }});
        await Store.destroy({ where: { z_id: zId }, transaction: t });

        const cityObj = await WhereService.greateCity(city);
        const suburbObj = await WhereService.greateSuburb(suburb, cityObj.id);
        let locationObj = null;
        if (location) locationObj = await WhereService.greateLocation(location, suburbObj.id);

        const cuisineNames = cuisines.split(',').map((c) => c.trim());
        const cuisineNameProms = cuisineNames.map((c) => CuisineService.greateCuisine(c));
        const cuisineObjs = await Promise.all(cuisineNameProms);

        const store = await Store.create({
          name: name,
          cover_image: coverImage,
          z_id: zId,
          z_url: zUrl,
          phone_country: phoneCountry,
          phone_number: phoneNumber,
          location_id: locationObj ? locationObj.id : null,
          suburb_id: suburbObj.id,
          city_id: cityObj.id,
          more_info: moreInfo,
          avg_cost: avgCost,
          coords: sequelize.literal(`POINT(${lat},${lng})`),
        }, { transaction: t });

        await StoreAddress.create({
          store_id: store.id,
          address_first_line: addressFirstLine,
          address_second_line: addressSecondLine,
          address_street_number: addressStreetNumber,
          address_street_name: addressStreetName,
          google_url: googleUrl,
        }, { transaction: t });

        const cuisineProms = cuisineObjs.map((cuisineObj) => StoreCuisine.create({
          store_id: store.id,
          cuisine_id: cuisineObj.id
        }, { transaction: t }));
        await Promise.all(cuisineProms);

        const hourProms = hours.split('\n').map((h, i) => {
          const splits = h.split('~');
          return StoreHour.create({ store_id: store.id, order: i+1, dotw: splits[0], hours: splits[1] }, { transaction: t });
        });
        await Promise.all(hourProms);

        return store;
      };

      try {
        return await sequelize.transaction(process);
      } catch (err) {
        throw Error(`Could not upsert store: ${err}`);
      }
    }
  },

  addStoreFollower: {
    type: StoreFollowType,
    args: {
      storeId: {
        type: new NonNull(Int),
      },
      followerId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, followerId }) => {
      const store = await Store.findByPk(storeId);
      if (store == null) throw Error(`Could not find Store by storeId: ${storeId}`);
      const follower = await UserAccount.findByPk(followerId);
      if (follower == null) throw Error(`Could not find UserAccount by followerId: ${followerId}`);
      const exist = await StoreFollow.findOne({ where: { store_id: storeId, follower_id: followerId } });
      if (exist != null) throw Error(`Follow already exists for storeId: ${storeId}, followerId: ${followerId}`);
      const follow = await StoreFollow.create({ store_id: storeId, follower_id: followerId });
      if (follow != null) await Store.increment('follower_count', { where: { id: storeId } });
      return follow;
    }
  },

  deleteStoreFollower: {
    type: StoreFollowType,
    args: {
      storeId: {
        type: new NonNull(Int),
      },
      followerId: {
        type: new NonNull(Int),
      },
    },
    resolve: async (_, { storeId, followerId }) => {
      const exist = await StoreFollow.findOne({ where: { store_id: storeId, follower_id: followerId } });
      if (exist == null) throw Error(`Could not find follow for storeId: ${storeId}, followerId: ${followerId}`);
      await exist.destroy();
      await Store.decrement('follower_count', { where: { id: storeId } })
      return exist;
    }
  },
};
