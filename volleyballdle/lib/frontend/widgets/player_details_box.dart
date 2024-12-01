import 'package:flutter/material.dart';
import '../../backend/player.dart';

class PlayerDetailsBox extends StatelessWidget {
  final Player player;

  const PlayerDetailsBox({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Today\'s player is:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          'Name: ${player.firstName} ${player.lastName}',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'League: ${player.currentLeague}',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Nationality: ${player.nationality}',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Age: ${player.age}',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Height: ${player.height} cm',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
