import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:frictionless_authentication/Screens/Enroll/enroll_page.dart';
import 'package:frictionless_authentication/Screens/Start_Page/start_page.dart';
import 'package:local_auth/local_auth.dart';

import '../../../constants.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: default_padding),
        child: Column(
          children: <Widget>[
            const SizedBox(height: default_padding),
            ElevatedButton(
              onPressed: () async {
                if (!supportState) {
                  Map<String, dynamic> data = {
                    'tokenApp': '0',
                    'tokenWeb': '1'
                  };
                  FirebaseFirestore.instance
                      .collection('Validation')
                      .doc('Token')
                      .set(data);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const StartPage();
                  }));
                }
                try {
                  authenticated = await auth.authenticate(
                    localizedReason: 'Confirm',
                    options: const AuthenticationOptions(
                      stickyAuth: true,
                      biometricOnly: true,
                    ),
                  );
                  if (authenticated) {
                    Map<String, dynamic> data = {
                      'tokenApp': '0',
                      'tokenWeb': '1'
                    };
                    FirebaseFirestore.instance
                        .collection('Validation')
                        .doc('Token')
                        .set(data);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const StartPage();
                      }));
                    });
                  }
                } on PlatformException catch (e) {
                  print(e);
                }
              },
              child: Text(
                "YES".toUpperCase(),
                style: TextStyle(color: secondary_colour),
              ),
            ),
            const SizedBox(height: default_padding),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const StartPage();
                }));
              },
              child: Text(
                "NO".toUpperCase(),
                style: TextStyle(color: secondary_colour),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
