const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

exports.toggleTrigger = functions.firestore.document('Messages/{messageId}')

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
