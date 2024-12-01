import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> _getUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(user.email).get();
      if (userDoc.exists) {
        // Assuming 'username' is stored as a field in Firestore
        return userDoc['email'] ?? 'Guest';
      }
    }
    return 'Guest'; // Fallback if the user or username is not found
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
        body: FutureBuilder<String>(
          future: _getUsername(), // Fetch username asynchronously
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Center(
                child: Text(
                  'Welcome, ${snapshot.data}!',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return Center(child: Text('Welcome, Guest!', style: TextStyle(fontSize: 20)));
            }
          },
        ),
      ),
    );
  }
}
