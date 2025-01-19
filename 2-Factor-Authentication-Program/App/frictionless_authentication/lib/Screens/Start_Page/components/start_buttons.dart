import 'package:flutter/material.dart';
// import 'package:frictionless_authentication/Screens/Enroll/enroll_page.dart';
import 'package:frictionless_authentication/Screens/EnrollDevice/enrolldevice_page.dart';
// import 'package:frictionless_authentication/Screens/Signin/signin_page.dart';

import '../../../constants.dart';

class EnrollBtn extends StatelessWidget {
  const EnrollBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero(
        //   tag: "signin_btn",
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) {
        //             return SigninPage();
        //           },
        //         ),
        //       );
        //     },
        //     child: Text(
        //       "Signin".toUpperCase(),
        //       style: TextStyle(color: Colors.black),
        //     ),
        //   ),
        // ),
        const SizedBox(height: 16),
        ElevatedButton(
          key: const Key('Enroll'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const EnrollDevicePage();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: secondary_colour, elevation: 0),
          child: Text(
            "Enroll device".toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
