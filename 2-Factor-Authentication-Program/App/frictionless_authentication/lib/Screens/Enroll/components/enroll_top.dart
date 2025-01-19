import 'package:flutter/material.dart';

import '../../../constants.dart';

class EnrollTop extends StatelessWidget {
  const EnrollTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 40;
    if (!isWeb) {
      if (isMobile) {
        size = 16;
      } else if (isDesktop) {
        size = 40;
      } else {
        size = 30;
      }
    }
    return Column(
      children: [
        Text(
          "Enter your e-mail address and password".toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size, color: Colors.white),
        ),
        const SizedBox(height: default_padding * 10),
      ],
    );
  }
}
