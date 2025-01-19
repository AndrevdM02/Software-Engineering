const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");
const cors = require("cors")({ origin: true });

admin.initializeApp();
const firestore = admin.firestore();
let userEmail = "";

// Initialization function that runs when Firebase is initialized
exports.initializeBackend = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      await generateKeyPair();
      return res.status(200).send("Backend initialized, Key pair generated.");
    } catch (error) {
      console.error("Error initializing backend:", error);
      return res.status(500).send("Error initializing backend.");
    }
  });
});

exports.generateOTP = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      
      userEmail = req.body.email;  
      const otpCollection = firestore.collection("OTPandEmail");
      const otp = generateOTP();
      const otpDocumentRef = await otpCollection.add({ "OTP": otp, "email": userEmail });
      setTimeout(async () => {
        // Delete the OTP document from Firestore
        await otpDocumentRef.delete();
      }, 60000);//60 seconds before OTP timeout
      
      console.log("Generated OTP, will expire after 60 seconds.");
      return res.status(200).send(otp);
    } catch (error) {
      console.error("Error generating OTP", error);
      return res.status(500).send("Error generating OTP.");
    }
  });
});

exports.SendEmailtoBackend = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      userEmail = req.body.email;
      const emailsCollection = firestore.collection("UserEmails");
      await emailsCollection.add({ email: userEmail });
      return res.status(200).send({ message: "Received and stored email" });
    } catch (error) {
      console.error("Error receiving email", error);
      return res.status(500).send({ message: "Failed to receive email." });
    }
  });
});
/*
* Will compare and validate OTP and Email
* Also decrypts the encrypted OTP that is received from App
*/
exports.registerDevice = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const OTP = req.body.OTP; // Assuming you send these as part of the request body
      const deviceId = req.body.deviceId;

      // Get a reference to the "OTPandEmail" collection
      const otpCollection = firestore.collection("OTPandEmail");

      // Query for the document with a matching OTP
      const otpQuery = otpCollection.where("OTP", "==", OTP).limit(1);

      // Execute the query and get the resulting documents
      const otpSnapshot = await otpQuery.get();

      if (otpSnapshot.empty) {
        return res.status(400).send("Invalid OTP");
      }

      // Access the email field from the first document in the snapshot
      const email = otpSnapshot.docs[0].get("email");
      // At this point, OTP is valid. Register the device
      const devicesCollection = firestore.collection("RegisteredDevices");
      await devicesCollection.add({
        "deviceId": deviceId,
        "email": email,
        "registeredAt": admin.firestore.Timestamp.now()  // store the timestamp of the registration
      });

      console.log(`Device ${deviceId} registered for ${email}.`);
      return res.status(200).send("Device registered successfully.");
    } catch (error) {
      console.error("Error registering device:", error);
      return res.status(500).send("Error registering device.");
    }
  });

});

/** Actual OTP gen */
async function generateKeyPair() {
  const { privateKey, publicKey } = crypto.generateKeyPairSync("rsa", {
    modulusLength: 2048,
    publicKeyEncoding: {
      type: "spki",
      format: "pem",
    },
    privateKeyEncoding: {
      type: "pkcs8",
      format: "pem",
    },
  });

  await admin.firestore().collection("Public Key").doc("Key").set({
    publicKey,
  });
  await admin.firestore().collection("Private Key").doc("Key").set({
    privateKey,
  });

  return "Public key generated.";
}
/** Generate the OTP
 * @return {String}
*/
function generateOTP() {
  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  return otp;
}


