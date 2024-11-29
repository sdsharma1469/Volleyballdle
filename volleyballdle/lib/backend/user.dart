import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  DateTime? lastLogin;
  String? lastQuestionCompleted;

  // Constructor
  UserModel({
    this.email,
    this.lastLogin,
    this.lastQuestionCompleted,
  });

  // Method to create a user document in Firestore
  Future<void> createUser() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Prepare user data
    final userData = {
      'email': email,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'lastQuestionCompleted': lastQuestionCompleted,
    };

    // Add user data to Firestore (users collection)
    try {
      await _firestore.collection('Users').doc(email).set(userData);
      print("User added to Firestore successfully!");
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }
}
