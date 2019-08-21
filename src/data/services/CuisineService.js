import { Cuisine } from '../models';

export default class CuisineService {

  static greateCuisine = async (name) => {
    const exist = await Cuisine.findOne({ where: { name: name }});
    if (exist != null) return exist;

    return await Cuisine.create({ name: name });
  };
}
