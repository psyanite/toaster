import * as Randomize from 'randomstring';
import sequelize from '../data/sequelize';

export default {
  generateCode() {
    let uniqueCode = Randomize.generate({ length: 5, charset: 'bcdfghjklmnpqrtvwxBCDFGHJKLMNPQRTVWX23456789' });
    return uniqueCode.toString();
  },
}
