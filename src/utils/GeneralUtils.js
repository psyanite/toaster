import * as Randomize from 'randomstring';
import sequelize from '../data/sequelize';

export default {
  generateCode() {
    let uniqueCode = Randomize.generate({ length: 5, charset: 'bcdfghjklmnpqrtvwxBCDFGHJKLMNPQRTVWX23456789' });
    return uniqueCode.toString();
  },

  resolveCoords(model) {
    return {
      type: 'Point',
      coordinates: [model.coords.x, model.coords.y],
      crs: {
        type: 'name',
        properties: {
          name: 'urn:ogc:def:crs:OGC:1.3:CRS84',
        },
      }
    }
  }
}
