import 'package:accountabill/pages/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static UserCredential? userCredential;
  static User? user;

  String get email => user?.email ?? '';
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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // print('User signed in: ${userCredential.user?.email}');
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
      Navigator.push(context, MaterialPageRoute(builder: (_) => AuthPage()));
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
