import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_page.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import '../../../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart' as pointycastle;

class LoggedInBtns extends StatelessWidget {
  const LoggedInBtns({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "enroll_btn",
          child: ElevatedButton(
            key: Key("enroll"),
            child: const Text("Enroll a device"),
            onPressed: () async {
              // String userEmail = getCurrentUserEmail();
              String encryptedOTP = '';
              String decryptedOTP = '';
              // Map<String, dynamic> data = {
              //   "email": userEmail
              // }; // Data is now a map
              // Lol when I tried this it broke it :D
              // http
              //     .post(
              //   Uri.parse(
              //       'https://us-central1-adrastea-bank.cloudfunctions.net/SendEmailtoBackend'),
              //   headers: {"Content-Type": "application/json"},
              //   body: json.encode(data), // Convert the map to a JSON string
              // )
              //     .then((response) {
              //   var jsonResponse = json.decode(response.body);
              //   if (response.statusCode == 200) {
              //     print(jsonResponse['message']);
              //   } else {
              //     print('Failed to send email');
              //   }
              // }).catchError((error) {
              //   print('Error: $error');
              // });

              String _OTPgen = await generateOTP();
              print("Received OTP: $_OTPgen");
              // Encryption testing Here

              CollectionReference publicKey =
                  FirebaseFirestore.instance.collection('Public Key');
              QuerySnapshot qSS = await publicKey.limit(1).get();
              if (qSS.docs.isNotEmpty) {
                Map<String, dynamic> data =
                    qSS.docs.first.data() as Map<String, dynamic>;
                String publicKey = data['publicKey'];
                print('Retrieved Public Key: $publicKey');
                encryptedOTP = encryptString(_OTPgen, publicKey);
                print('Encrypted otp: $encryptedOTP');
              } else {
                print('No documents found in the collection.');
              }

              CollectionReference privateKey =
                  FirebaseFirestore.instance.collection('Private Key');
              QuerySnapshot qSSp = await privateKey.limit(1).get();
              if (qSSp.docs.isNotEmpty) {
                Map<String, dynamic> data1 =
                    qSSp.docs.first.data() as Map<String, dynamic>;
                String privateKey = data1['privateKey'];
                print('Retrieved Private Key: $privateKey');
                String decryptedotp = decryptString(encryptedOTP, privateKey);
                print('Decrypted OTP: $decryptedotp');
              } else {
                print('Could not retreive private key');
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  Future.delayed(Duration(seconds: 60), () {
                    Navigator.of(context)
                        .pop(); // Close the dialog after 60 seconds
                  });

                  return AlertDialog(
                    scrollable: true,
                    title: const Text("OTP: Expires in 60 seconds"),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: [
                            Text(
                              _OTPgen,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [],
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          key: Key("signout"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return WelcomePage();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: SecondaryColour, elevation: 0),
          child: Text(
            "Sign out".toUpperCase(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

Future<String> generateOTP() async {
  String userEmail = getCurrentUserEmail();
  Map<String, dynamic> data = {"email": userEmail};

  final response = await http.post(
    Uri.parse(
        'https://us-central1-adrastea-bank.cloudfunctions.net/generateOTP'),
    headers: {"Content-Type": "application/json"},
    body: json.encode(data),
  );

  if (response.statusCode == 200) {
    final otp = response.body;
    print('OTP: $otp');
    return otp;
  } else {
    print('Failed to fetch OTP');
    return '0';
  }
}

String getCurrentUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  String userEmail = '';
  if (user != null) {
    userEmail = user.email!;
    return userEmail;
  } else {
    return '';
  }
}

pointycastle.RSAPublicKey? parseRSAPublicKey(String publicKey) {
  final rsaParser = encrypt.RSAKeyParser();
  if (publicKey.isEmpty) {
    return null; // Return null if publicKey is empty
  }
  return rsaParser.parse(publicKey) as pointycastle.RSAPublicKey;
}

pointycastle.RSAPrivateKey? parseRSAPrivateKey(String privateKey) {
  final rsaParser = encrypt.RSAKeyParser();
  if (privateKey.isEmpty) {
    return null; // Return null if privateKey is empty
  }
  return rsaParser.parse(privateKey) as pointycastle.RSAPrivateKey;
}

String encryptString(String plainText, String publicKey) {
  final pubkey = parseRSAPublicKey(publicKey);

  if (pubkey == null) {
    throw Exception("Invalid public key");
  }

  final encrypter = OAEPEncoding(RSAEngine())
    ..init(true,
        pointycastle.PublicKeyParameter<pointycastle.RSAPublicKey>(pubkey));

  final Uint8List encrypted =
      encrypter.process(Uint8List.fromList(plainText.codeUnits));

  return base64Encode(encrypted);
}

String decryptString(String encryptedText, String privateKey) {
  final prikey = parseRSAPrivateKey(privateKey);

  if (prikey == null) {
    throw Exception("Invalid private key");
  }

  final encrypter = OAEPEncoding(RSAEngine())
    ..init(false,
        pointycastle.PrivateKeyParameter<pointycastle.RSAPrivateKey>(prikey));

  final Uint8List encrypted = base64Decode(encryptedText);
  final Uint8List decrypted = encrypter.process(Uint8List.fromList(encrypted));

  return String.fromCharCodes(decrypted);
}
