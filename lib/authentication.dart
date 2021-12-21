import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/user_image_picker.dart';

import 'Login.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthenticationForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;

    try {
      if (isLogin) {
        // Login
        authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password
        );
      } else {
        //sign upt
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid)
            .set({
          'user-name': username,
          'password': password,
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erorr';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Login(_submitAuthenticationForm),
    );
  }
}
