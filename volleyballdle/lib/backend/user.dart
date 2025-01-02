import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyballdle/frontend/frontendfunctions.dart/welcomepagefunctions.dart';

class UserModel {
  String? email;
  DateTime? lastLogin;
  String? lastQuestionCompleted;
  List<String> completedQuestions;
  int streak; // Added streak field

  // Constructor
  UserModel({
    this.email,
    this.lastLogin,
    this.lastQuestionCompleted,
    List<String>? completedQuestions,
    this.streak = 0, // Initialize streak to 0
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
      'streak': streak, // Add streak to Firestore data
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

    bool completedToday = await hasCompletedQuestionToday();
    if (!completedQuestions.contains(questionId)) {
      completedQuestions.add(questionId);
      await _updateCompletedQuestionsInFirestore();
      print("Question $questionId marked as completed!");
    }

    if (completedToday) {
      print("Question already completed today. Streak not updated.");
      return;
    }

    // Update streak logic
    DateTime now = DateTime.now();
    if (lastLogin != null && _isYesterday(lastLogin!)) {
      streak += 1; // Increment streak if the user guessed correctly yesterday
    } else {
      streak = 1; // Reset streak if it's not a consecutive day
    }

    await _updateStreakInFirestore();
    updateLastCompletedQuestion(questionId);
  }

  // Check if two dates are consecutive days
  bool _isYesterday(DateTime date) {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  Future<void> updateLastCompletedQuestion(String questionId) async {
    if (email == null) {
      print("Error: Email is null");
      return;
    }
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('Users').doc(email).update({
        'lastQuestionCompleted': questionId, // Update the last completed question
      });
      print("Last completed question updated successfully!");
    } catch (e) {
      print("Error updating last completed question in Firestore: $e");
    }
  }

  Future<void> _updateStreakInFirestore() async {
    if (email == null) {
      print("Error: Email is null");
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('Users').doc(email).update({
        'streak': streak,
      });
      print("Streak updated in Firestore successfully!");
    } catch (e) {
      print("Error updating streak in Firestore: $e");
    }
  }

  Future<bool> hasCompletedQuestionToday() async {
    String? todaysQuestionID = await getTodaysQuestionID();
    return lastQuestionCompleted == todaysQuestionID;
  }

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
          streak: data['streak'] ?? 0, // Fetch the streak value
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
      return null;
    }
  }

  String? getEmail() {
    return this.email;
  }
}
