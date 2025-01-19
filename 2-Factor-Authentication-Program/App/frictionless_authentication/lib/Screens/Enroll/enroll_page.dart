import 'package:flutter/material.dart';
import 'package:frictionless_authentication/Screens/Enroll/components/enroll_buttons.dart';
import 'package:frictionless_authentication/Screens/Enroll/components/enroll_top.dart';
import '../../components/background.dart';

class EnrollPage extends StatelessWidget {
  const EnrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          EnrollTop(),
          Row(
            children: [
              Spacer(),
              Expanded(
                flex: 8,
                child: EnrollButtons(),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
