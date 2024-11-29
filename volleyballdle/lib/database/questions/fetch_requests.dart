import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> fetchData() async {
  print("running request");
  try {
    QuerySnapshot snapshot = await _firestore.collection('Players').get();
    for (var doc in snapshot.docs) {
      //print(doc.data());  // Print document data
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
}

