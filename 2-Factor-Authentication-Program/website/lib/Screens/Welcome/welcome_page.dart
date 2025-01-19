import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/components/tabs.dart';
import '../../components/background.dart';
import '../../constants.dart';
import 'components/welcome_buttons.dart';
import 'components/welcome_details.dart';
import 'components/navbar.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Navbar(),
              Tabs(),
              const SizedBox(height: defaultPadding),
              WelcomeDetails(),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: LoginAndSignupBtn(),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
