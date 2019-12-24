import * as firebaseAdmin from 'firebase-admin';
import serverKey from '../../../secrets/firebase-admin.json';

firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serverKey),
});

export default firebaseAdmin;
