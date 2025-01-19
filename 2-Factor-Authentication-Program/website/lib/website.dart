import 'package:flutter/material.dart';
import 'Screens/Welcome/welcome_page.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';

class Website extends StatelessWidget {
  final Future<FirebaseApp> app;
  Website({required this.app});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking_Website',
      theme: ThemeData(
          primaryColor: MainColour,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: MainColour,
              shape: StadiumBorder(),
              maximumSize: Size(double.infinity, 48),
              minimumSize: Size(double.infinity, 48),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: SecondaryColour,
            iconColor: MainColour,
            prefixIconColor: MainColour,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: WelcomePage(),
    );
  }
}
