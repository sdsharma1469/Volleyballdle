import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
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
      ),
    );
  }
}
