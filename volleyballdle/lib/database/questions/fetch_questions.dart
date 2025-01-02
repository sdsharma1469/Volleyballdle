import 'package:cloud_firestore/cloud_firestore.dart';
import '../../backend/player.dart';

Future<void> fetchData() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('Players').get();
    List<Player> players = snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
    for(var player in players){
      print(player.firstName);
    }
  } catch (e) {
    print('Error fetching player data: $e');
  }
}

Future<Player?> fetchTodaysPlayer() async {
  try {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);  // Start of the day (00:00:00)
    DateTime endOfDay = startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));  // End of the day (23:59:59)
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('Players').get();
    List<Player> players = snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
    for (var player in players) {
      if (player.date != null) {
        if (player.date!.isAfter(startOfDay) && player.date!.isBefore(endOfDay)) {
          //print('Fetched Player');
          return player; 
        }
      }
    }
  } catch (e) {
    print('Error fetching player data: $e');
  }
  return null; 
}
