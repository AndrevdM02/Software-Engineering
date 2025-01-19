import 'package:flutter/material.dart';
import 'website.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<FirebaseApp> app = Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCUPEHPmJBls7DagyZQVLDM1RxAg359ZLI",
      authDomain: "adrastea-bank.firebaseapp.com",
      projectId: "adrastea-bank",
      storageBucket: "adrastea-bank.appspot.com",
      messagingSenderId: "888356628538",
      appId: "1:888356628538:web:0032ad3e03e6e0fa5e2d03",
      measurementId: "G-7X6R1LEL5T",
    ),
  );
  runApp(Website(app: app));
  InitializeBackend();
}

final functionEndpoint =
    'https://us-central1-adrastea-bank.cloudfunctions.net/initializeBackend';

Future<void> InitializeBackend() async {
  try {
    final response = await http.get(Uri.parse(functionEndpoint));

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
    } else {
      throw Exception('Failed to trigger the function');
    }
  } catch (error) {
    print('Error: $error');
  }
}
