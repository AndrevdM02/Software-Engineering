import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class WelcomeDetails extends StatelessWidget {
  const WelcomeDetails({
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
            "WELCOME TO ADRASTEA BANK!",
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
              "Discover the possibilities by signing up with us today! By becoming a member, you'll gain access to a world of convenience and opportunities. From effortless online transactions to personalized financial insights, our platform is designed to empower you. Plus, with our top-tier security measures in place, you can trust that your information is safe and sound. Don't miss out on the benefits that await - join us now to embark on a journey of seamless banking and financial growth!",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: defaultPadding * 2),
          //---Way to insert an image in the welcome page---
          // Row(
          //   children: [
          //     Spacer(),
          //     Expanded(
          //       flex: 8,
          //       child: SvgPicture.asset(
          //         "assets/icons/Empty.svg",
          //       ),
          //     ),
          //     Spacer(),
          //   ],
          // ),
          // SizedBox(height: defaultPadding * 2),
        ],
      ),
    );
  }
}
