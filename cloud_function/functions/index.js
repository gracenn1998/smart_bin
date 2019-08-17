const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();



// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


//exports.senNoti2= functions.firestore.document('users/{uID}/binList/{tID}')
exports.senNoti2= functions.firestore.document('STB/{tID}')
                                    .onUpdate((change, context) => {
//      console.log('updated');
//      const userID = context.params.uID;
      const tID = context.params.tID;
      const bin1 = change.after.data()['bin1'];
      const bin2 = change.after.data()['bin2'];
//      const bin1Pre = change.previousData.data['bin1'];
//      const bin2Pre = change.previousData.data['bin2'];

//      console.log(bin1);


      if(bin1 == true || bin2 == true) {
        var msg = {
                notification: {
                    title: 'Full Bin Announcement',
                    body: 'Some sub-bins of bin ' + tID + ' have been full',
                },
                data : {
                    "click_action": "FLUTTER_NOTIFICATION_CLICK",
                    'tID' : tID,
                    'bin1' : bin1.toString(),
                    'bin2' : bin2.toString(),
                }
              };
         admin.messaging().sendToTopic(tID, msg).then((response) => {
            console.log("Success", response);
         })
         .catch((error) => {
            console.log("Error", error);
            return false;
         });

      }

    return true;

});