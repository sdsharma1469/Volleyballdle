import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Use a getter to access the user's email
  String? get userEmail {
    User? userInstance = _auth.currentUser;
    return userInstance?.email;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/');
        return true; // Allow pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome Page'),
        ),
        body: Center(
          child: Text(
            userEmail != null
                ? 'Welcome, $userEmail!'
                : 'Welcome, Guest!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
