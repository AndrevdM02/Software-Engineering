import 'package:flutter/material.dart';

import '../../../constants.dart';

class EnrollDeviceTop extends StatelessWidget {
  const EnrollDeviceTop({
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
          "Please enter the OTP on your device".toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size, color: Colors.white),
        ),
        const SizedBox(height: default_padding * 5),
      ],
    );
  }
}
