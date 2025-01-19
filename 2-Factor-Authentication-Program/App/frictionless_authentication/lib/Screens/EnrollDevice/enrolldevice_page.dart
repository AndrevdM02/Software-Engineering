// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frictionless_authentication/Screens/EnrollDevice/components/enrolldevice_buttons.dart';
import 'package:frictionless_authentication/Screens/EnrollDevice/components/enrolldevice_top.dart';
import 'package:frictionless_authentication/components/background.dart';

class EnrollDevicePage extends StatelessWidget {
  const EnrollDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          EnrollDeviceTop(),
          Row(
            children: [
              Spacer(),
              Expanded(
                flex: 8,
                child: EnrollDeviceButtons(),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
