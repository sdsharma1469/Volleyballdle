import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<void> populateDB() async {
  final String response = await rootBundle.loadString('players.json');
  final List<dynamic> players = json.decode(response);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  for (var player in players) {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Players')
          .where('nationality', isEqualTo: player['nationality'])
          .where('firstName', isEqualTo: player['firstName'])
          .where('lastName', isEqualTo: player['lastName'])
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await firestore.collection('Players').doc(doc.id).set(player);
          print("Player updated: ${player['firstName']} ${player['lastName']}");
        }
      } else {
        await firestore.collection('Players').add(player);
        print("Player added: ${player['firstName']} ${player['lastName']}");
      }
    } catch (e) {
      print("Failed to process player: ${player['firstName']} ${player['lastName']}. Error: $e");
    }
  }
  print("All players processed successfully!");
}
