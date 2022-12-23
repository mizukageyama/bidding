const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

const SENDGRID_API_KEY = functions.config().sendgrid.key;

const sendGridEmail = require("@sendgrid/mail");
sendGridEmail.setApiKey(SENDGRID_API_KEY);

exports.sendEmailToAuctionWinner = functions.https.onCall((data, context) => {
  const msg = {
    "from": {
      "email": "bidonline22@gmail.com",
    },
    "personalizations": [
      {
        "to": [
          {
            "email": data.winner_email,
          },
        ],
        "dynamic_template_data": {
          "otp": data.otp,
          "first_name": data.first_name,
          "item_id": data.item_id,
          "item_title": data.item_title,
          "item_condition": data.item_condition,
          "item_category": data.item_category,
          "asking_price": data.asking_price,
          "winning_bid": data.winning_bid,
          "seller_name": data.seller_name,
          "seller_email": data.seller_email,
          "seller_number": data.seller_number,
          "item_photo": data.item_photo,
        },
      },
    ],
    "template_id": "d-08007f94fa93405b938a6dbb55af0825",
  };
  try {
    sendGridEmail.send(msg);
    return console.log("email sent");
  } catch (error) {
    throw new functions.https.HttpsError('error', error.toString());
  }
});
