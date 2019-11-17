import * as Randomize from 'randomstring';

export default {
  generateCode() {
    const options = { length: 5, charset: 'bcdfghjklmnpqrtvwxBCDFGHJKLMNPQRTVWX23456789' };
    return Randomize.generate(options).toString();
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
  },

  tsClean(query) {
    return query.trim().replace(/\s+/g, ' | ');
  },
}
