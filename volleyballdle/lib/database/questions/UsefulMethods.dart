import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyballdle/backend/player.dart';

Future<Player?> getPlayerByID(String playerID) async {
  try {
    // Reference the 'Players' collection and fetch the document with the given ID
    DocumentSnapshot playerDoc = await FirebaseFirestore.instance
        .collection('Players')
        .doc(playerID)
        .get();

    if (playerDoc.exists) {
      // Convert the document snapshot to a Player object
      return Player.fromFirestore(playerDoc);
    } else {
      // Handle case where no document exists with the given ID
      print('No player found with ID: $playerID');
    }
  } catch (e) {
    // Handle errors during the fetch
    print('Error fetching player by ID: $e');
  }

  return null; // Return null if no player is found or an error occurs
}
