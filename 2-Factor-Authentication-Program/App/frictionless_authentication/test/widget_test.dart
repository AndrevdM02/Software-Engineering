// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frictionless_authentication/Screens/EnrollDevice/enrolldevice_page.dart';
import 'package:frictionless_authentication/Screens/Start_Page/components/start_buttons.dart';
import 'package:frictionless_authentication/Screens/Start_Page/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}

Widget makeTestableWidget({Widget? child}) {
  return MaterialApp(
    home: child,
  );
}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Start Page', () {
    testWidgets('Start Page top', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: StartPage()));
      await tester.pump();
      expect(find.text('WELCOME TO\n   ADRASTEA'), findsOneWidget);
      expect(find.text('Please enter the OTP on your device'), findsNothing);
    });

    testWidgets('Start Page Buttons and navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: EnrollBtn()));
      await tester.tap(find.byKey(Key('Enroll')));
      await tester.pump();
      await tester.pump();
      expect(find.text("Please enter the OTP on your device".toUpperCase()),
          findsOneWidget);
    });
  });

  group('Enroll Page', () {
    testWidgets('Enroll page top', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: EnrollDevicePage()));
      await tester.pump();
      expect(find.text("Please enter the OTP on your device".toUpperCase()),
          findsOneWidget);
    });

    testWidgets('Enroll Page back to start Page', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: EnrollDevicePage()));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byKey(Key('Back')));
      await tester.pump();
      await tester.pump();
      expect(find.text('WELCOME TO\n   ADRASTEA'), findsOneWidget);
      expect(find.text('Please enter the OTP on your device'), findsNothing);
    });

    // testWidgets('Enroll Page Unsuccesful enrollment',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(makeTestableWidget(child: EnrollDevicePage()));
    //   await tester.pump();
    //   await tester.pump();
    //   Finder _OTP = find.byKey(const Key("_OTP"));
    //   await tester.enterText(_OTP, '000001');
    //   await tester.tap(find.byKey(const Key("Enrollment")));
    //   await tester.pump(Duration(seconds: 3));
    //   expect(find.text("Please enter the OTP on your device".toUpperCase()),
    //       findsOneWidget);
    //   expect(find.text('Please Authenticate your sign in'), findsNothing);
    // });

    // testWidgets('Enroll Page Succesful enrollment',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(makeTestableWidget(child: EnrollDevicePage()));
    //   await tester.pump();
    //   await tester.pump();
    //   Finder _OTP = find.byKey(const Key("_OTP"));
    //   await tester.enterText(_OTP, '000000');
    //   await tester.tap(find.byKey(const Key("Enrollment")));
    //   await tester.pump();
    //   await tester.pump();
    //   // expect(find.text("Please enter the OTP on your device".toUpperCase()),
    //   //     findsOneWidget);
    //   // expect(find.text('Please Authenticate your sign in'), findsNothing);
    //   // expect(find.text("Please Authenticate your sign in".toUpperCase()),
    //   //     findsOneWidget);
    // });
  });
}
