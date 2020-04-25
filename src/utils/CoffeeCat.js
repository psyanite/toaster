import Utils from './Utils';
import superagent from 'superagent';
import configs from '../configs';

const Hook = {
  Alert: 'https://hooks.slack.com/services/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',
}

function doPost(hook, emoji, msg, callback) {
  superagent
    .post(hook)
    .set('Content-Type', 'application/json')
    .send({ text: `${emoji} ${msg.slice(0, 1000)}` })
    .then(callback)
    .catch((e) => {
      const eMsg = `Could not send message: ${JSON.stringify(msg)}`;
      Utils.error(() => {
        console.error(eMsg);
        console.error(e);
      });
      return eMsg;
    });
}

function mkCallback(msg) {
  return () => Utils.log(`CoffeeCat - Message sent, ${msg}`)
}

export const Emoji = {
  Success: ':tada:',
  Info: ':sparkles:',
  Warn: ':exclamation:',
  Error: ':rotating_light:',
}

export default class CoffeeCat {

  static msgAlert(emoji, title, msg) {
    const titleStr = title !== '' ? `*${title}* - ` : '';
    const env = configs.envCode;
    const now  = Utils.nowServerFmt();
    const callback = mkCallback(msg)
    doPost(Hook.Alert, emoji, `${now} - ${env} - ${titleStr}${msg}`, callback);
  }

}
