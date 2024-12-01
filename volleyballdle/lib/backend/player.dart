import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String id; // Firestore document ID
  String currentLeague;
  String nationality;
  String firstName;
  int age;
  String lastName;
  int height;
  DateTime? date; // Field to store the date

  // Constructor to initialize the Player object
  Player({
    required this.id,
    required this.currentLeague,
    required this.nationality,
    required this.firstName,
    required this.age,
    required this.lastName,
    required this.height,
    this.date,
  });

    // Factory constructor to create a Player from Firestore document data
  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Player(
      id: doc.id, // Retrieve the Firestore document ID
      currentLeague: data['currentLeague'] ?? '',
      nationality: data['nationality'] ?? '',
      firstName: data['firstName'] ?? '',
      age: data['age'] ?? 0,
      lastName: data['lastName'] ?? '',
      height: data['height'] ?? 0,
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null, 
    );
  }



  // Method to display player details
  void printPlayerDetails() {
    print('Player Details:');
    print('Full Name: $firstName $lastName');
    print('League: $currentLeague');
    print('Nationality: $nationality');
    print('Age: $age');
    print('Height: $height cm');
    print('Date: $date');
    print('Document ID: $id');
  }

  // Method to return the document ID
  String getDocumentId() {
    return id;
  }
   @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Check if both are the same object
    if (other is! Player) return false; // Check if the other object is of type Player
    return other.firstName == firstName && other.lastName == lastName; // Compare based on first and last names
  }

  // Overriding hashCode to be consistent with the == operator
  @override
  int get hashCode => firstName.hashCode ^ lastName.hashCode;
}
