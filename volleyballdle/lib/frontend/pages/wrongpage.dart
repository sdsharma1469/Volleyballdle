import 'package:flutter/material.dart';
import 'package:volleyballdle/backend/user.dart';
import 'userpage.dart'; // Import the UserPage widget

class WrongPage extends StatelessWidget {
  final UserModel user;
  final String questionId;

  WrongPage({required this.user, required this.questionId});

  @override
  Widget build(BuildContext context) {
    _markQuestionAsCompleted();
    return Scaffold(
      appBar: AppBar(
        title: Text('Oops!'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Oops, you got it wrong!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Text(
                'Try again tomorrow for a new question!',
                style: TextStyle(fontSize: 16.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text('Go to Home'),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('View Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _markQuestionAsCompleted() async {
    try {
      await user.completeQuestion(questionId);
    } catch (e) {
      print('Error updating question for user: $e');
    }
  }
}
