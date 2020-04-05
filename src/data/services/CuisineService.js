import { Cuisine } from '../models';

export default class CuisineService {

  static async greateCuisine(name) {
    const exist = await Cuisine.findOne({ where: { name: name }});
    if (exist != null) return exist;

    return Cuisine.create({ name: name });
  };
}
