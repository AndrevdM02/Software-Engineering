import 'package:flutter/material.dart';
import 'package:frictionless_authentication/Screens/EnrollDevice/enrolldevice_page.dart';
import 'package:frictionless_authentication/Screens/Start_Page/start_page.dart';
import 'package:frictionless_authentication/constants.dart';

class EnrollButtons extends StatelessWidget {
  const EnrollButtons({
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: main_colour,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Your email",
                hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(default_padding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: default_padding),
            TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: main_colour,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Your password",
                hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(default_padding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: default_padding),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const EnrollDevicePage();
                }));
              },
              child: const Text(
                "ENROLL DEVICE",
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
              child: const Text(
                "BACK",
                style: TextStyle(color: secondary_colour),
              ),
            ),
            const SizedBox(height: default_padding),
            // AlreadyHaveAnAccountCheck(
            //   login: false,
            //   press: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return EnrollPage();
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
