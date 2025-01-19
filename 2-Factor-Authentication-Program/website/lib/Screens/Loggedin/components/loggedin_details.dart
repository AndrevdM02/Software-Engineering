import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class LoggedInDetails extends StatelessWidget {
  const LoggedInDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          //---Welcome message---
          Text(
            "LOGGED IN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(height: defaultPadding * 2),
          //---Description---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 5),
            child: Text(
              "Please enroll a mobile device using the Adrastea banking app to enable two factor authentication to finish creating an account.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: defaultPadding * 2),
        ],
      ),
    );
  }
}
