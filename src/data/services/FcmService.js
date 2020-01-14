import { burntoastAdmin, butterAdmin} from './FirebaseAdminService';
import Utils from '../../utils/Utils';

const burntoastMessenger = burntoastAdmin.messaging();
const butterMessenger = butterAdmin.messaging();

const fcm = {
  burntoast: 'burntoast',
  butter: 'butter',
};

const clickActionKey = 'FLUTTER_NOTIFICATION_CLICK';

function getMessenger(fcmName) {
  switch (fcmName) {
    case fcm.burntoast: return burntoastMessenger;
    case fcm.butter: return butterMessenger;
    default: Utils.error(() => {
      console.error(`Could not recognise fcm: ${fcmName}`);
    })
  }
}

function buildMessage({ token, title, body, imageUrl, data }) {
  return {
    notification: {
      ...(title && { title }),
      ...(body && { body }),
      ...(imageUrl && { imageUrl }),
    },
    data: {
      click_action: clickActionKey,
      ...data
    },
    token,
  };
}

function sendMessage(messenger, message) {
  if (message.token == null) return "Token is null";

  try {
    return messenger.send(message)
      .then((response) => {
        const msg = `Successfully sent message: ${JSON.stringify(message)} \n response: ${response}`;
        Utils.debug(msg);
        return msg;
      })
      .catch((e) => {
        const msg = `Could not send message: ${JSON.stringify(message)}`;
        Utils.error(() => {
          console.error(msg);
          console.error(e);
        });
      })
  } catch (e) {
    const msg = `Could not send message: ${JSON.stringify(message)}`;
    Utils.error(() => {
      console.error(msg);
      console.error(e);
    });
    return msg;
  }
}

export default class FcmService {

  static notifyPost(fcm, { token, title, body, imageUrl, postId, flashComment, flashReply }) {
    const messenger = getMessenger(fcm);

    const data = {
      goto: 'post',
      postId: postId.toString(),
      ...(flashComment && {flashComment: flashComment.toString()}),
      ...(flashReply && {flashReply: flashReply.toString()}),
    };

    const message = buildMessage({ token, title, body, imageUrl, data });
    return sendMessage(messenger, message);
  };

}

FcmService.fcm = fcm;
