import { City, Location } from '../models';

export default class WhereService {

  static async greateLocation(name, suburbId) {
    const exist = await Location.findOne({ where: { name: name }});
    if (exist != null) return exist;

    return Location.create({
      name: name,
      suburb_id: suburbId,
    });
  };

  static async greateCity(name) {
    const exist = await City.findOne({ where: { name: name }});
    if (exist != null) return exist;

    return City.create({
      name: name,
      district_id: 1,
    });
  };
}
