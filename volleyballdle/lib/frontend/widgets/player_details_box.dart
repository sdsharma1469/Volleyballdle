import 'package:flutter/material.dart';
import '../../backend/player.dart';

class PlayerDetailsBox extends StatelessWidget {
  final Player player;

  const PlayerDetailsBox({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFieldBox('Name', '${player.firstName} ${player.lastName}'),
          _buildFieldBox('League', player.currentLeague),
          _buildFieldBox('Nationality', player.nationality),
          _buildFieldBox('Age', '${player.age}'),
          _buildFieldBox('Height', '${player.height} cm'),
          _buildFieldBox('Position', player.position),
        ],
      ),
    );
  }

  Widget _buildFieldBox(String label, String value) {
    return Container(
      width: 120, // Fixed width for each box
      margin: EdgeInsets.symmetric(horizontal: 4), // Spacing between boxes
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100, // Background color
        border: Border.all(color: Colors.blue.shade300), // Border color
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
