import * as firebaseAdmin from 'firebase-admin';
import burntoastServerKey from '../../../secrets/firebase-admin-burntoast.json';
import butterServerKey from '../../../secrets/firebase-admin-butter.json';

if (!firebaseAdmin.apps.length) {
  firebaseAdmin.initializeApp({
    credential: firebaseAdmin.credential.cert(burntoastServerKey),
  }, "burntoast");

  firebaseAdmin.initializeApp({
    credential: firebaseAdmin.credential.cert(butterServerKey),
  }, "butter");
}

const burntoastAdmin = firebaseAdmin.app("burntoast");
const butterAdmin = firebaseAdmin.app("butter");

export { burntoastAdmin, butterAdmin };
