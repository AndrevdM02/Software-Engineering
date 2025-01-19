import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 100;
    if (!isWeb) {
      if (isMobile) {
        size = 50;
      } else if (isDesktop) {
        size = 100;
      } else {
        size = 80;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: default_padding),
      child: Column(
        children: [
          //---Welcome message---
          Text(
            "WELCOME TO\n   ADRASTEA",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size,
            ),
          ),
          const SizedBox(height: default_padding * 5),
        ],
      ),
    );
  }
}
