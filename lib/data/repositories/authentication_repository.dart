import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationRepository extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static UserCredential? userCredential;
  static User? user;

  String? get userId => _auth.currentUser?.uid;
  String get email => _auth.currentUser?.email ?? '';
  AuthCredential? get authCredential => userCredential?.credential;
  bool get hasUser => _auth.currentUser != null;

  Future<bool> signUp(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      // print('User signed up: ${userCredential.user?.email}');
      userCredential = userCredential;
      user = userCredential.user;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create user")));
      return false;
    }
  }

  Future<bool> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print('User signed in: ${userCredential.user?.email}');
      userCredential = userCredential;
      user = userCredential.user;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to authenticate")));
      return false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      await _auth.signOut();
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Successfully logged out")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error logging out')));
    }
  }
}
