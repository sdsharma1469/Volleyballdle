import 'package:volleyballdle/backend/player.dart';
import 'package:volleyballdle/backend/useful_functions.dart';
import 'package:volleyballdle/backend/user.dart';

final UsefulFunctions _functions = UsefulFunctions();

// Format strings (e.g., names)
String formatString(String input) => _functions.formatString(input);

// Get today's player from Firestore
Future<Player?> getTodaysPlayer() async => _functions.getTodaysPlayer();

// Compare two players
Map<String, String> comparePlayers(Player player1, Player player2) =>
    _functions.comparePlayers(player1, player2);

// Fetch player by name
Future<Player?> getPlayerByName(String firstName, String lastName) async {
  final formattedFirstName = formatString(firstName);
  final formattedLastName = formatString(lastName);
  return _functions.getPlayerByName(formattedFirstName, formattedLastName);
}

// Fetch the current user
Future<UserModel?> getUser() async => _functions.getUser();

// Get today's question ID
Future<String?> getTodaysQuestionID() async => _functions.getTodaysQuestionID();

Future<String> getUserEmail() async {
  final UsefulFunctions _functions = UsefulFunctions();
  return await _functions.getEmail();
}

