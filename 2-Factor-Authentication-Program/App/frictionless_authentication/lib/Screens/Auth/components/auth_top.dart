import 'package:flutter/material.dart';

import '../../../constants.dart';

class AuthTop extends StatelessWidget {
  const AuthTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 40;
    if (!isWeb) {
      if (isMobile) {
        size = 18;
      } else if (isDesktop) {
        size = 40;
      } else {
        size = 30;
      }
    }
    return Column(
      children: [
        Text(
          "Please Authenticate your sign in".toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size, color: Colors.white),
        ),
        const SizedBox(height: default_padding * 20),
      ],
    );
  }
}
