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
  String position; // Added position field

  // Constructor to initialize the Player object
  Player({
    required this.id,
    required this.currentLeague,
    required this.nationality,
    required this.firstName,
    required this.age,
    required this.lastName,
    required this.height,
    required this.position, // Initialize position
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
      position: data['position'] ?? '', // Retrieve position
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
    );
  }

  // Format first and last names by cleaning them
  Player formatted() {
    return Player(
      id: id,
      currentLeague: currentLeague,
      nationality: nationality,
      firstName: _cleanString(firstName),
      age: age,
      lastName: _cleanString(lastName),
      height: height,
      position: position,
      date: date,
    );
  }

  String _cleanString(String input) {
    // Convert to lowercase and remove any non-alphanumeric characters (spaces, special characters, etc.)
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  // Method to display player details
  void printPlayerDetails() {
    print('Player Details:');
    print('Full Name: $firstName $lastName');
    print('League: $currentLeague');
    print('Nationality: $nationality');
    print('Age: $age');
    print('Height: $height cm');
    print('Position: $position');
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
    // Compare all fields for equality
    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.age == age &&
        other.height == height &&
        other.position == position &&
        other.nationality == nationality &&
        other.currentLeague == currentLeague; // Check more fields
  }

  // Overriding hashCode to be consistent with the == operator
  @override
  int get hashCode => firstName.hashCode ^
      lastName.hashCode ^
      age.hashCode ^
      height.hashCode ^
      position.hashCode ^
      nationality.hashCode ^
      currentLeague.hashCode;
}
