import { Location, Suburb, City } from '../models';

export default class WhereService {

  static greateLocation = async (name, suburbId) => {
    const exist = await Location.findOne({ where: { name: name }});
    if (exist != null) return exist;

    return await Location.create({
      name: name,
      suburb_id: suburbId,
    });
  };

  static greateSuburb = async (name, cityId) => {
    const exist = await Suburb.findOne({ where: { name: name }});
    if (exist != null) return exist;

    return await Suburb.create({
      name: name,
      city_id: cityId,
    });
  };

  static greateCity = async (name) => {
    const exist = await City.findOne({ where: { name: name }});
    if (exist != null) return exist;

    return await City.create({
      name: name,
      district_id: 1,
    });
  };
}
