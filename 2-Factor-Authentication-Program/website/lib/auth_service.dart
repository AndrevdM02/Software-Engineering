import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      // print(error.toString());
      return null;
    }
  }

  // Register with email & password
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
        'email': email
      });

      return user;
    } catch (error) {
      // print(error.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (error) {
      // print(error.toString());
      return null;
    }
  }
}
