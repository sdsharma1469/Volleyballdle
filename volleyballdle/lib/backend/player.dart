import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  // Define the properties of the Player class
  String currentLeague;
  int height;
  String lastName;
  String nationality;
  String firstName;
  int age;

  // Constructor to initialize the Player object
  Player({
    required this.currentLeague,
    required this.height,
    required this.lastName,
    required this.nationality,
    required this.firstName,
    required this.age,
  });

  // Convert a Player object to a map that can be stored in Firestore
  Map<String, dynamic> toMap() {
    return {
      'Current_League': currentLeague,
      'Height': height,
      'Last_Name': lastName,
      'Nationality': nationality,
      'First_Name': firstName,
      'Age': age,
    };
  }

  // Create a Player object from a Firestore document snapshot
  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Player(
      currentLeague: data['Current_League'],
      height: data['Height'],
      lastName: data['Last_Name'],
      nationality: data['Nationality'],
      firstName: data['First_Name'],
      age: data['Age'],
    );
  }

  // Save the Player object to Firestore
  Future<void> saveToFirestore() async {
    CollectionReference players = FirebaseFirestore.instance.collection('players');
    await players.add(toMap());
  }

  // Fetch all players from Firestore
  static Future<List<Player>> fetchPlayers() async {
    CollectionReference players = FirebaseFirestore.instance.collection('players');
    QuerySnapshot querySnapshot = await players.get();
    List<Player> playerList = querySnapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
    return playerList;
  }
}
