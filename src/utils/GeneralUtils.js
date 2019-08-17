import * as Randomize from 'randomstring';

export default {
  generateCode() {
    let uniqueCode = Randomize.generate({ length: 5, charset: 'bcdfghjklmnpqrtvwxBCDFGHJKLMNPQRTVWX23456789' });
    return uniqueCode.toString();
  },
}
