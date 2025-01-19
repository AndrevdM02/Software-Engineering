import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart'; //(For importing an image)

import '../../../constants.dart';

class LoginTop extends StatelessWidget {
  const LoginTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Log In".toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: defaultPadding * 10),
      ],
    );
  }
}
