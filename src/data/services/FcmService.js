import { User } from '../models';
import sequelize from '../sequelize';
import Sequelize from 'sequelize';

import firebaseAdmin from './FirebaseAdminService';

const messenger = firebaseAdmin.messaging();

export default class FcmService {

  static async sendMessage(userId, token, title, message) {
    const body = {
      data: { userId, title, message },
      token: token,
    };

    messenger.send(body)
      .then((response) => {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
      })
      .catch((error) => {
        console.log('Error sending message:', error);
      });
  }
}
