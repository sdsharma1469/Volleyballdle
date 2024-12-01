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

  Future<String> getUsername() async {
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
    String firstName,
    String lastName,
    Function(String message, bool isCorrect) onResult,
  ) {
    // Format the strings to lower case and remove spaces
    String formattedFirstName = formatString(firstName);
    String formattedLastName = formatString(lastName);

    if (player != null) {
      String formattedPlayerFirstName = formatString(player.firstName);
      String formattedPlayerLastName = formatString(player.lastName);

      // Check if the formatted names match
      if (formattedPlayerFirstName == formattedFirstName &&
          formattedPlayerLastName == formattedLastName) {
        onResult('Yay! The player is ${player.firstName} ${player.lastName}.', true);
        completeQuestion('player_guess_question');
      } else {
        onResult('Incorrect, try again.', false);
      }
    } else {
      print("Player is null. UGH!");
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


  String formatString(String s1) {
    // Convert string to lowercase and remove spaces
    return s1.toLowerCase().replaceAll(' ', '');
  }
}
