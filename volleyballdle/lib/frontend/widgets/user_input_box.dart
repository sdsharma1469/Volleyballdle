import 'package:flutter/material.dart';

class UserInputBox extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final Function(String, String) onSubmit;
  final String message;
  final bool isCorrect;

  const UserInputBox({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.onSubmit,
    required this.message,
    required this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: firstNameController,
          decoration: InputDecoration(labelText: 'Enter First Name'),
        ),
        TextField(
          controller: lastNameController,
          decoration: InputDecoration(labelText: 'Enter Last Name'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => onSubmit(firstNameController.text, lastNameController.text),
          child: Text('Submit Guess'),
        ),
        SizedBox(height: 20),
        Text(
          message,
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
