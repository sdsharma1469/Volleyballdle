import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  DateTime? lastLogin;
  String? lastQuestionCompleted;
  List<String> completedQuestions;

  // Constructor
  UserModel({
    this.email,
    this.lastLogin,
    this.lastQuestionCompleted,
    List<String>? completedQuestions,
  }) : completedQuestions = completedQuestions ?? []; // Use an empty list if none is provided

  // Create user in Firestore
  Future<void> createUser() async {
    if (email == null) {
      print("Error: Email is null");
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userData = {
      'email': email,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'lastQuestionCompleted': lastQuestionCompleted,
      'completedQuestions': completedQuestions,
    };

    try {
      await _firestore.collection('Users').doc(email).set(userData);
      print("User added to Firestore successfully!");
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }

  // Mark a question as completed and update Firestore
  Future<void> completeQuestion(String questionId) async {
    if (email == null) {
      print("Error: Email is null");
      return;
    }

    if (!completedQuestions.contains(questionId)) {
      completedQuestions.add(questionId);
      await _updateCompletedQuestionsInFirestore();
      print("Question $questionId marked as completed!");
    } else {
      print("Question $questionId is already completed.");
    }
  }

  // Check if a question is completed
  bool isQuestionCompleted(String questionId) {
    return completedQuestions.contains(questionId);
  }

  // Private method to update completedQuestions in Firestore
  Future<void> _updateCompletedQuestionsInFirestore() async {
    if (email == null) {
      print("Error: Email is null");
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('Users').doc(email).update({
        'completedQuestions': completedQuestions,
      });
      print("Completed questions updated in Firestore successfully!");
    } catch (e) {
      print("Error updating completed questions in Firestore: $e");
    }
  }

  // Method to fetch user data from Firestore
  static Future<UserModel?> fetchUser(String email) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(email).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        return UserModel(
          email: data['email'],
          lastLogin: data['lastLogin']?.toDate(),
          lastQuestionCompleted: data['lastQuestionCompleted'],
          completedQuestions: List<String>.from(data['completedQuestions'] ?? []),
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
      return null;
    }
  }
}
