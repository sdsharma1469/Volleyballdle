import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyballdle/backend/player.dart';
import '../../backend/user.dart';
import '../../database/questions/fetch_questions.dart';

class UsefulFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Player?> getTodaysPlayer() async {
    return await fetchTodaysPlayer();
  }

  Future<String> getEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .get();
      if (userDoc.exists) {
        return userDoc['email'] ?? 'Guest';
      }
    }
    return 'Guest';
  }

  Future<String?> getTodaysQuestionID() async {
    try {
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day); // Start of the day (00:00:00)
      DateTime endOfDay = startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1)); // End of the day (23:59:59)
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('Players').get();
      List<Player> players = snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();

      for (var player in players) {
        if (player.date != null) {
          if (player.date!.isAfter(startOfDay) && player.date!.isBefore(endOfDay)) {
            return snapshot.docs.firstWhere((doc) => doc.id == player.id).id; // Return the ID of the matching player
          }
        }
      }
    } catch (e) {
      print('Error fetching player data: $e'); // Retain error print
    }
    return null; // Return null if no player matches today's date
  }

 Future<UserModel?> getUser() async {
  User? firebaseUser = _auth.currentUser; // Get the current Firebase user
  if (firebaseUser == null) {
    return null; // Return null if no user is logged in
  }
  try {
    // Fetch additional user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(firebaseUser.email)
        .get();

    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>;
      return UserModel(
        email: data['email'],
        lastLogin: data['lastLogin']?.toDate(),
        lastQuestionCompleted: data['lastQuestionCompleted'],
        completedQuestions: List<String>.from(data['completedQuestions'] ?? []),
        streak: data['streak'] ?? 0, // Safely handle streak
      );
    } else {
      // If no Firestore document exists, create a default UserModel
      return UserModel(email: firebaseUser.email, completedQuestions: []);
    }
  } catch (e) {
    print("Error fetching user data: $e");
    return null;
  }
}


  Future<void> completeQuestion(String questionId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      UserModel userModel = UserModel(email: user.email);
      await userModel.completeQuestion(questionId);
    }
  }

  Future<Player?> getPlayerByName(String firstName, String lastName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Players')
        .where('firstName', isEqualTo: firstName)
        .where('lastName', isEqualTo: lastName)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return Player.fromFirestore(querySnapshot.docs.first);
    }
    return null;
  }

  void checkAnswer(
    Player? player,
    String? firstName,
    String? lastName,
    Function(String message, bool isCorrect) onResult,
  ) {
    // Format the strings to lower case and remove spaces
    String formattedFirstName = formatString(firstName);
    String formattedLastName = formatString(lastName);

    if (player != null) {
      String formattedPlayerFirstName = formatString(player.firstName);
      String formattedPlayerLastName = formatString(player.lastName);
      if (formattedPlayerFirstName == formattedFirstName &&
          formattedPlayerLastName == formattedLastName) {
        onResult('Yay! The player is ${player.firstName} ${player.lastName}.', true);
        completeQuestion('player_guess_question');
      } else {
        onResult('Incorrect, try again.', false);
      }
    } else {
      onResult('Incorrect, try again.', false);
    }
  }

  void checkAnswerPlayerToPlayer(Player? player1, Player? player2, Function(String message, bool isCorrect) onResult) {
    if (player1 == player2) {
      onResult('Yay! The players match.', true);
    } else {
      onResult('Incorrect, players do not match.', false);
    }
  }

  String formatString(String? s1) {
    // Convert string to lowercase and remove spaces
    if (s1 == null) return '';
    return s1.toLowerCase().replaceAll(' ', '');
  }

  Map<String, String> comparePlayers(Player actualPlayer, Player guessedPlayer) {
    Map<String, String> comparisonResults = {};

    if (actualPlayer.firstName.toLowerCase() == guessedPlayer.firstName.toLowerCase()) {
      comparisonResults['First Name'] = 'Correct';
    } else {
      comparisonResults['First Name'] = 'Wrong';
    }

    // Compare last name
    if (actualPlayer.lastName.toLowerCase() == guessedPlayer.lastName.toLowerCase()) {
      comparisonResults['Last Name'] = 'Correct';
    } else {
      comparisonResults['Last Name'] = 'Wrong';
    }

    // Compare nationality
    if (actualPlayer.nationality.toLowerCase() == guessedPlayer.nationality.toLowerCase()) {
      comparisonResults['Nationality'] = 'Correct';
    } else {
      comparisonResults['Nationality'] = 'Wrong';
    }

    // Compare age
    if (actualPlayer.age == guessedPlayer.age) {
      comparisonResults['Age'] = 'Correct';
    } else if (actualPlayer.age > guessedPlayer.age) {
      comparisonResults['Age'] = 'Higher';
    } else {
      comparisonResults['Age'] = 'Lower';
    }

    // Compare height
    if (actualPlayer.height == guessedPlayer.height) {
      comparisonResults['Height'] = 'Correct';
    } else if (actualPlayer.height > guessedPlayer.height) {
      comparisonResults['Height'] = 'Higher';
    } else {
      comparisonResults['Height'] = 'Lower';
    }

    // Compare position
    if (actualPlayer.position.toLowerCase() == guessedPlayer.position.toLowerCase()) {
      comparisonResults['Position'] = 'Correct';
    } else {
      comparisonResults['Position'] = 'Wrong';
    }

    return comparisonResults;
  }
}
