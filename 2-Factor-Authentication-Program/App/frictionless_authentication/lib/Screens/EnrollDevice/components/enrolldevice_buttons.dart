import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:frictionless_authentication/Screens/Auth/auth_page.dart';
import 'package:frictionless_authentication/Screens/EnrollDevice/enrolldevice_page.dart';
// import 'package:frictionless_authentication/Screens/Enroll/enroll_page.dart';
import 'package:frictionless_authentication/Screens/Start_Page/start_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:io'; // Required for Platform.isAndroid/isIOS
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart' as pointycastle;

import '../../../constants.dart';

TextEditingController _OTP = TextEditingController();

class EnrollDeviceButtons extends StatelessWidget {
  const EnrollDeviceButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: default_padding),
        child: Column(
          children: [
            TextFormField(
              key: const Key("_OTP"),
              controller: _OTP,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              cursorColor: main_colour,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: "Enter your OTP",
                hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                counterStyle: TextStyle(color: Colors.white),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(default_padding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: default_padding),
            ElevatedButton(
              key: const Key("Enrollment"),
              onPressed: () async {
                CollectionReference publicKey =
                    FirebaseFirestore.instance.collection('Public Key');
                QuerySnapshot qSS = await publicKey.limit(1).get();
                if (qSS.docs.isNotEmpty) {
                  Map<String, dynamic> data =
                      qSS.docs.first.data() as Map<String, dynamic>;
                  String publicKey = data['publicKey'];

                  print('Retrieved Public Key: $publicKey');
                  print(encryptString(_OTP.text, publicKey));
                } else {
                  print('No documents found in the collection.');
                }

                int result = await sendOTPtoBackend(_OTP.text);

                // AwesomeNotifications().createNotification(
                //     content: NotificationContent(
                //       id: 11,
                //       channelKey: 'auth_channel',
                //       title: 'Please Authenticate',
                //       body: 'Authenticate a sign in',
                //     ),
                //     actionButtons: [
                //       NotificationActionButton(
                //           key: 'auth_channel', label: 'auth_notifications'),
                //     ]);

                if (!context.mounted) return;
                String msg;
                if (result == 1) {
                  msg = "Device Succesfully Enrolled.";
                } else {
                  msg = "Device Unsuccesfully Enrolled.";
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text("OTP"),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: [
                              Text(
                                msg,
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

                await Future.delayed(const Duration(
                    seconds: 1)); //changed to 1 sec to make it faster, was 2s
                if (!context.mounted) return;

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  if (result == 1) {
                    return const StartPage();
                  }
                  return const EnrollDevicePage();
                }));
              },
              child: const Text(
                "ENTER",
                style: TextStyle(color: secondary_colour),
              ),
            ),
            const SizedBox(height: default_padding),
            ElevatedButton(
              key: const Key("Back"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const StartPage();
                }));
              },
              child: const Text(
                "BACK",
                style: TextStyle(color: secondary_colour),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> sendOTPtoBackend(String otp) async {
  String id = await getDeviceId() ?? "";
  //String id = "123456";

  Map<String, String> data = {'OTP': otp, 'deviceId': id};
  final response = await http.post(
      Uri.parse(
          'https://us-central1-adrastea-bank.cloudfunctions.net/registerDevice'),
      body: data);
  if (response.statusCode == 200) {
    print("OTP matched!");
    return 1;
  } else if (response.statusCode == 400) {
    print("OTP incorrect!");
    return 0;
  }
  return 0;
}

final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

Future<String?> getDeviceId() async {
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
    return iosInfo
        .identifierForVendor; // This is unique to the device across apps
  }
  return null;
}

pointycastle.RSAPublicKey? parseRSAPublicKey(String publicKey) {
  final rsaParser = encrypt.RSAKeyParser();
  if (publicKey.isEmpty) {
    return null; // Return null if publicKey is empty
  }
  return rsaParser.parse(publicKey) as pointycastle.RSAPublicKey;
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
