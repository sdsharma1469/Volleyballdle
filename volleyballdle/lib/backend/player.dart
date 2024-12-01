import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String currentLeague;
  String nationality;
  String firstName;
  int age;
  String lastName;
  int height;
  DateTime? date; // Field to store the date

  // Constructor to initialize the Player object
  Player({
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
      currentLeague: data['Current_League'] ?? '',
      nationality: data['Nationality'] ?? '',
      firstName: data['First_Name'] ?? '',
      age: data['Age'] ?? 0,
      lastName: data['Last_Name'] ?? '',
      height: data['Height'] ?? 0,
      date: data['Date']?.toDate(),  // Assuming 'Date' is a Timestamp in Firestore
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
  }
}
