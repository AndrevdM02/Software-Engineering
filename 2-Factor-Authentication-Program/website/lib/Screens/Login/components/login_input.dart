import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/auth_service.dart';
import '../../../components/already_account.dart';
import '../../../constants.dart';
import '../../Signup/signup_page.dart';
import '../../Welcome/welcome_page.dart';
import '../../Loggedin/loggedin_page.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            TextFormField(
              key: Key("mail"),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: defaultPadding),
            TextFormField(
              key: Key("pass"),
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Hero(
              tag: "login_btn",
              child: ElevatedButton(
                key: Key("logged"),
                onPressed: () async {
                  final String email = _emailController.text;
                  final String password = _passwordController.text;
                  dynamic result =
                      await _auth.signInWithEmailAndPassword(email, password);
                  if (result == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Incorrect user name or password'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    String deviceID = await checkDevice(email);
                    if (deviceID == "0") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return LoggedInPage();
                        }),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: const Text("Validate"),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                child: Column(
                                  children: [
                                    Text(
                                      "Validate login on device",
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
                      Map<String, dynamic> data = {
                        'tokenApp': '1',
                        'tokenWeb': '0'
                      };
                      FirebaseFirestore.instance
                          .collection('Validation')
                          .doc('Token')
                          .set(data);
                      int flag = 1;

                      while (flag == 1) {
                        //hello
                        CollectionReference Validation =
                            FirebaseFirestore.instance.collection('Validation');
                        QuerySnapshot ValidationSnap = await Validation.get();
                        for (QueryDocumentSnapshot doc in ValidationSnap.docs) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          String? token = data['tokenWeb'];
                          if (token == "1") {
                            flag = 0;
                            Map<String, dynamic> data = {
                              'tokenApp': '0',
                              'tokenWeb': '0',
                            };
                            FirebaseFirestore.instance
                                .collection('Validation')
                                .doc('Token')
                                .set(data);
                          }
                        }
                      }
                      if (flag == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return LoggedInPage();
                          }),
                        );
                      }
                    }
                  }
                },
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: MainColour),
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              key: Key("back"),
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
              child: Text(
                "BACK",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: MainColour),
            ),
            AlreadyHaveAnAccountCheck(
              key: Key("signup"),
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignupPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> checkDevice(String email) async {
  CollectionReference RegisteredDevices =
      FirebaseFirestore.instance.collection('RegisteredDevices');
  QuerySnapshot DeviceSnap = await RegisteredDevices.get();
  String device = "0";
  for (QueryDocumentSnapshot doc in DeviceSnap.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String? emailIn = data['email'];
    if (emailIn != null) {
      if (emailIn.toLowerCase() == email.toLowerCase()) {
        if (data['deviceId'] != null) {
          device = data['deviceId'];
          print("device is not null:");
          print(device);
        }
        break;
      } else {
        device = "0";
      }
    } else {
      device = "0";
    }
  }
  return device;
}
