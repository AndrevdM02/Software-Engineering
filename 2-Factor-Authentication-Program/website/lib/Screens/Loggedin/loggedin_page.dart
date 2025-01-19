import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Loggedin/components/tabs.dart';
import '../../components/background.dart';
import '../../constants.dart';
import 'components/loggedin_buttons.dart';
import 'components/loggedin_details.dart';
import 'components/navbar.dart';

class LoggedInPage extends StatelessWidget {
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
              LoggedInDetails(),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: LoggedInBtns(),
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
