// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Loggedin/loggedin_page.dart';
import 'package:flutter_auth/Screens/Signup/signup_page.dart';
import 'package:flutter_auth/auth_service.dart';
import 'package:flutter_auth/website.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';

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

class MockFirebase extends Mock implements FirebaseFirestore {}

class MockAuthservice extends Mock implements AuthService {
  MockFirebase _firestore = MockFirebase();
  @override
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  @override
  Future registerWithEmailAndPassword(String email, String password,
      String name, String surname, String phoneNumber) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Create a new document for the user with the uid
      await _firestore.collection('users').doc(user!.uid).set({
        'name': name,
        'surname': surname,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password
      });

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

Future<void> main() async {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group("Start page", () {
    testWidgets("Start Up page", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      Future<FirebaseApp> app = Firebase.initializeApp();
      await tester.pumpWidget(makeTestableWidget(child: Website(app: app)));
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
    });

    testWidgets("Go to login page", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      Future<FirebaseApp> app = Firebase.initializeApp();
      await tester.pumpWidget(makeTestableWidget(child: Website(app: app)));
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
      await tester.tap(find.byKey(Key("login")));
      await tester.pump();
      await tester.pump();
      expect(find.text("Log In".toUpperCase()), findsOneWidget);
      expect(find.text("Your email"), findsOneWidget);
    });

    testWidgets("Go to sign up page", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      Future<FirebaseApp> app = Firebase.initializeApp();
      await tester.pumpWidget(makeTestableWidget(child: Website(app: app)));
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
      await tester.ensureVisible(find.byKey(Key("sign_up")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("sign_up")));
      await tester.pump();
      await tester.pump();
      expect(find.text("Registration".toUpperCase()), findsOneWidget);
    });
  });
  group("Signup Functionality", () {
    testWidgets("Go back to Welcome Page", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      expect(find.text("Registration".toUpperCase()), findsOneWidget);
      await tester.ensureVisible(find.byKey(Key("back")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("back")));
      await tester.pump();
      await tester.pump();
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsWidgets);
      expect(find.text("LOGIN"), findsWidgets);
    });

    testWidgets("Fill in invalid name", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder nameField = find.byKey(Key("name"));
      await tester.enterText(nameField, "A");
      await tester.pumpAndSettle();
      expect(find.text("Invalid name."), findsOneWidget);
      await tester.enterText(nameField, "Student");
      await tester.pumpAndSettle();
      expect(find.text("Invalid name."), findsNothing);
    });

    testWidgets("Fill in invalid surname", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder surnameField = find.byKey(Key("surname"));
      await tester.enterText(surnameField, "A");
      await tester.pumpAndSettle();
      expect(find.text("Invalid surname."), findsOneWidget);
      await tester.enterText(surnameField, "Stellies");
      await tester.pumpAndSettle();
      expect(find.text("Invalid surname."), findsNothing);
    });
    testWidgets("Fill in invalid phone number", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder phoneField = find.byKey(Key("phone"));
      await tester.enterText(phoneField, "071156789");
      await tester.pumpAndSettle();
      expect(find.text("Invalid phone number."), findsOneWidget);
      await tester.enterText(phoneField, "0711567894");
      await tester.pumpAndSettle();
      expect(find.text("Invalid phone number."), findsNothing);
    });

    testWidgets("Fill in invalid email", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder emailField = find.byKey(Key("email"));
      await tester.enterText(emailField, "A");
      await tester.pumpAndSettle();
      expect(find.text("Invalid email adress."), findsOneWidget);
      await tester.enterText(emailField, "Student@Stellies1.com");
      await tester.pumpAndSettle();
      expect(find.text("Invalid email adress."), findsNothing);
    });

    testWidgets("Fill in invalid password (Upper case)",
        (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "a");
      await tester.pumpAndSettle();
      expect(find.text("Requires at least one uppercase character."),
          findsOneWidget);
    });

    testWidgets("Fill in invalid password (lowercase)",
        (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "A");
      await tester.pumpAndSettle();
      expect(find.text("Requires at least one lowercase character."),
          findsOneWidget);
    });

    testWidgets("Fill in invalid password (Empty)",
        (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "A");
      await tester.pumpAndSettle();
      expect(find.text("Requires at least one lowercase character."),
          findsOneWidget);

      await tester.enterText(passwordField, "");
      await tester.pumpAndSettle();
      expect(find.text("Can\'t be empty."), findsOneWidget);
    });

    testWidgets("Fill in invalid password (digit)",
        (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "As");
      await tester.pumpAndSettle();
      expect(
          find.text("Requires at least one digit character."), findsOneWidget);

      await tester.enterText(passwordField, "As1");
      await tester.pumpAndSettle();
      expect(find.text("Must be at least 8 characters"), findsOneWidget);
    });

    testWidgets("Fill in invalid password (length)",
        (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "As1");
      await tester.pumpAndSettle();
      expect(find.text("Must be at least 8 characters"), findsOneWidget);
    });

    testWidgets("Valid password", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "Stellies123");
      await tester.pumpAndSettle();
      expect(find.text("Must be at least 8 characters"), findsNothing);
      expect(find.text("Requires at least one uppercase character."),
          findsNothing);
      expect(find.text("Requires at least one uppercase character."),
          findsNothing);
      expect(find.text("Requires at least one digit character."), findsNothing);
      expect(find.text("Can\'t be empty."), findsNothing);
    });

    testWidgets("confirm password mismatch", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "Stellies123");
      Finder confirmpasswordField = find.byKey(Key("confirm"));
      await tester.enterText(confirmpasswordField, "Stellies12");
      await tester.pumpAndSettle();
      expect(find.text("Password mismatch"), findsOneWidget);
    });
    testWidgets("confirm password", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "Stellies123");
      Finder confirmpasswordField = find.byKey(Key("confirm"));
      await tester.enterText(confirmpasswordField, "Stellies123");
      await tester.pumpAndSettle();
      expect(find.text("Password mismatch"), findsNothing);
    });
    testWidgets("visible password", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "Stellies123");
      await tester.ensureVisible(find.byKey(Key("view1")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("view1")));
      await tester.pumpAndSettle();
      expect(find.text("Stellies123"), findsOneWidget);
    });

    testWidgets("visible confirm password", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder confirmpasswordField = find.byKey(Key("confirm"));
      await tester.enterText(confirmpasswordField, "Stellies123");
      await tester.ensureVisible(find.byKey(Key("view2")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("view2")));
      await tester.pumpAndSettle();
      expect(find.text("Stellies123"), findsOneWidget);
    });

    testWidgets("unsuccessful sign-up", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder nameField = find.byKey(Key("name"));
      await tester.enterText(nameField, "Student");

      Finder surnameField = find.byKey(Key("surname"));
      await tester.enterText(surnameField, "Stellies");

      Finder phoneField = find.byKey(Key("phone"));
      await tester.enterText(phoneField, "0711567894");

      Finder emailField = find.byKey(Key("email"));
      await tester.enterText(emailField, "Student@Stellies.com");

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "Stellies123");

      Finder confirmpasswordField = find.byKey(Key("confirm"));
      await tester.enterText(confirmpasswordField, "Stellies123");

      await tester.ensureVisible(find.byKey(Key("signup")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("signup")));
      await tester.pump();
    });

    testWidgets("successful sign-up", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      MockAuthservice _auth = MockAuthservice();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      Finder nameField = find.byKey(Key("name"));
      await tester.enterText(nameField, "Student");

      Finder surnameField = find.byKey(Key("surname"));
      await tester.enterText(surnameField, "Stellies");

      Finder phoneField = find.byKey(Key("phone"));
      await tester.enterText(phoneField, "0711567894");

      Finder emailField = find.byKey(Key("email"));
      await tester.enterText(emailField, "Student@Stellies1.com");

      Finder passwordField = find.byKey(Key("password"));
      await tester.enterText(passwordField, "Stellies123");

      Finder confirmpasswordField = find.byKey(Key("confirm"));
      await tester.enterText(confirmpasswordField, "Stellies123");

      await _auth.registerWithEmailAndPassword("Student@Stellies.com",
          "stellies123", "student", "stellies", "071 456 5644");

      await tester.ensureVisible(find.byKey(Key("signup")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("signup")));
      await tester.pumpAndSettle();

      dynamic result = await _auth.signInWithEmailAndPassword(
          "Student@Stellies.com", "stellies123");
      expect(result, null);
    });

    testWidgets("navigate from signup to login", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      await tester.pumpWidget(makeTestableWidget(child: SignupPage()));
      await tester.ensureVisible(find.byKey(Key("signin")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("signin")));
      await tester.pump(kDoubleTapTimeout);
      await tester.tap(find.byKey(Key("sign-up")));
      await tester.pumpAndSettle();
      expect(find.text("Log in".toUpperCase()), findsOneWidget);
    });
  });
  group("Login Functionality", () {
    testWidgets("Go back to Welcome Page", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      Future<FirebaseApp> app = Firebase.initializeApp();
      await tester.pumpWidget(makeTestableWidget(child: Website(app: app)));
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
      await tester.tap(find.byKey(Key("login")));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byKey(Key("back")));
      await tester.pump();
      await tester.pump();
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsWidgets);
      expect(find.text("LOGIN"), findsWidgets);
    });

    testWidgets("unsuccessful login", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      MockAuthservice _auth = MockAuthservice();
      Future<FirebaseApp> app = Firebase.initializeApp();
      await tester.pumpWidget(makeTestableWidget(child: Website(app: app)));
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
      await tester.tap(find.byKey(Key("login")));
      await tester.pump();
      await tester.pump();
      Finder emailField = find.byKey(Key("mail"));
      await tester.enterText(emailField, " ");

      Finder passwordField = find.byKey(Key("pass"));
      await tester.enterText(passwordField, " ");
      await tester.ensureVisible(find.byKey(Key("logged")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("logged")));
      await tester.pump();
      await tester.pump();
      dynamic result = await _auth.signInWithEmailAndPassword(" ", " ");
      expect(result, null);
    });

    testWidgets("successful login", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      MockAuthservice _auth = MockAuthservice();
      Future<FirebaseApp> app = Firebase.initializeApp();
      await tester.pumpWidget(makeTestableWidget(child: Website(app: app)));
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
      await tester.tap(find.byKey(Key("login")));
      await tester.pump();
      await tester.pump();
      Finder emailField = find.byKey(Key("mail"));
      await tester.enterText(emailField, "Student@Stellies.com");
      Finder passwordField = find.byKey(Key("pass"));
      await tester.enterText(passwordField, "stellies123");
      await _auth.registerWithEmailAndPassword("Student@Stellies.com",
          "stellies123", "student", "stellies", "071 456 5644");

      await tester.ensureVisible(find.byKey(Key("logged")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("logged")));

      dynamic result = await _auth.signInWithEmailAndPassword(
          "Student@Stellies.com", "stellies123");
      expect(result, null);
    });

    testWidgets("navigate from login to signup", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      Future<FirebaseApp> app = Firebase.initializeApp();
      await tester.pumpWidget(makeTestableWidget(child: Website(app: app)));
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
      await tester.tap(find.byKey(Key("login")));
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byKey(Key("signup")));
      await tester.pump(kDoubleTapTimeout);
      await tester.tap(find.byKey(Key("sign-up")));
      await tester.pumpAndSettle();
      expect(find.text("Registration".toUpperCase()), findsOneWidget);
    });
  });

  group("Logged in functionality", () {
    testWidgets("Logged in top", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      // MockAuthservice _auth = MockAuthservice();
      await tester.pumpWidget(makeTestableWidget(child: LoggedInPage()));
      expect(find.text("LOGGED IN"), findsOneWidget);
      expect(find.text("Adrastea Bank"), findsOneWidget);
    });

    // testWidgets("Enroll a Device", (WidgetTester tester) async {
    //   // final AuthService auth = AuthService();
    //   // MockAuthservice _auth = MockAuthservice();
    //   await tester.pumpWidget(makeTestableWidget(child: LoggedInPage()));
    //   await tester.ensureVisible(find.byKey(Key("enroll")));
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.byKey(Key("enroll")));
    //   await tester.pumpAndSettle();
    //   // expect(find.widgetWithText(AlertDialog, "OTP"), findsOneWidget);
    // });

    testWidgets("Sign out", (WidgetTester tester) async {
      // final AuthService auth = AuthService();
      // MockAuthservice _auth = MockAuthservice();
      await tester.pumpWidget(makeTestableWidget(child: LoggedInPage()));
      await tester.ensureVisible(find.byKey(Key("signout")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("signout")));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AlertDialog, "OTP"), findsNothing);
      expect(find.text("WELCOME TO ADRASTEA BANK!"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
    });
  });
}
