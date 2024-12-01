import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcomepage.dart';
import '../../backend/user.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _signInWithEmailPassword() async {
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // If sign-in is successful, update the last login time in Firestore
      if (userCredential.user != null) {
        DocumentReference userDocRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.email);

        await userDocRef.update({
          "lastLogin": FieldValue.serverTimestamp(), // Update last login timestamp
        });

        // Navigate to the Welcome Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    } catch (e) {
      // Handle errors
      if (e.toString().contains('user-not-found')) {
        // User not found, delete Firestore document
        DocumentReference userDocRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(_emailController.text);

        await userDocRef.delete(); // Delete the Firestore document
        print("User document deleted from Firestore because the email does not exist in Firebase Auth.");
      } else if (e.toString().contains('wrong-password')) {
        // Incorrect password, show error message
        setState(() {
          _errorMessage = "Incorrect password. Please try again.";
        });
      } else {
        // Other errors
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }




  Future<void> _registerWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        UserModel newUser = UserModel(
          email: userCredential.user!.email,
          lastLogin: DateTime.now(), 
          lastQuestionCompleted: null,
        );
        await newUser.createUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login / Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmailPassword,
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: _registerWithEmailPassword,
              child: Text('Register'),
            ),
            SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

