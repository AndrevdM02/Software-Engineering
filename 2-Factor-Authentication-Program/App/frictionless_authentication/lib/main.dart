import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frictionless_authentication/Screens/Auth/auth_page.dart';
import 'package:frictionless_authentication/Screens/Start_Page/start_page.dart';
import 'package:frictionless_authentication/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

bool msg = false;

class NotificationController {
  static ReceivedAction? initialAction;
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'auth_channel',
          channelName: 'Adrastea',
          channelDescription: 'Notification channel for auth tests',
          playSound: true,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.blue,
          ledColor: Colors.blue,
        )
      ],
      debug: true,
    );

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction) {
      if (receivedAction.payload != null) {
        //////////////////////////////
        print(receivedAction.payload!["payload"]!);
        ////////////////////////////
      }
    } else {
      if (receivedAction.payload != null) {
        ////////////////////////
        print(receivedAction.payload!["payload"]!);
      }
    }
  }
}

Future<void> main() async {
  await NotificationController.initializeLocalNotifications();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCUPEHPmJBls7DagyZQVLDM1RxAg359ZLI",
        authDomain: "adrastea-bank.firebaseapp.com",
        projectId: "adrastea-bank",
        storageBucket: "adrastea-bank.appspot.com",
        appId: "1:888356628538:web:0032ad3e03e6e0fa5e2d03",
        messagingSenderId: "888356628538",
        measurementId: "G-7X6R1LEL5T"),
  );
  FirebaseMessaging.onBackgroundMessage(_handler);
  int result = 0;
  CollectionReference Validation =
      FirebaseFirestore.instance.collection('Validation');
  QuerySnapshot ValidationSnap = await Validation.get();
  for (QueryDocumentSnapshot doc in ValidationSnap.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String? token = data['tokenApp'];
    if (token == "1") {
      result = 1;
      Map<String, dynamic> data = {
        'tokenApp': '0',
        'tokenWeb': '0',
      };
      FirebaseFirestore.instance
          .collection('Validation')
          .doc('Token')
          .set(data);
    } else {
      result = 0;
    }
  }
  if (result == 1) {
    msg = true;
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 11,
          channelKey: 'auth_channel',
          title: 'Please Authenticate',
          body: 'Authenticate a sign in',
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'auth_channel', label: 'auth_notifications'),
        ]);
  } else {
    msg = false;
  }
  print(result);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ReceivedAction? receivedAction;

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    receivedAction = NotificationController.initialAction;
    super.initState();
  }

  // This widget is the root of the app
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 11,
            channelKey: 'auth_channel',
            title: 'Please Authenticate',
            body: 'Authenticate a sign in',
          ),
          actionButtons: [
            NotificationActionButton(
                key: 'auth_channel', label: 'auth_notifications'),
          ]);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frictionless Authentication',
      theme: ThemeData(
          // Theme of the app
          primaryColor: main_colour,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: main_colour,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 48),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: secondary_colour,
            iconColor: main_colour,
            prefixIconColor: main_colour,
            contentPadding: EdgeInsets.symmetric(
                horizontal: default_padding, vertical: default_padding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: receivedAction?.channelKey == 'auth_channel' || msg
          ? AuthPage()
          : StartPage(),
    );
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enrollment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); //close
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  print('Username: $username, Password: $password');
                  Navigator.of(context).pop();
                },
                child: Text('Login'),
              )
            ],
          );
        });
  }
}

Future<void> _handler(RemoteMessage message) async {
  print("Message is ${message.data}");
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 11,
        channelKey: 'auth_channel',
        title: 'Please Authenticate',
        body: 'Authenticate a sign in',
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'auth_channel', label: 'auth_notifications'),
      ]);
  // AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> SendValidationPromptToApp() async {
  final response = await http.get(Uri.parse(
      'https://us-central1-adrastea-bank.cloudfunctions.net/SendValidationPromptToApp'));
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("Device received validation!");
  } else if (response.statusCode == 400) {
    print("Device is not trusted!");
  }
}
