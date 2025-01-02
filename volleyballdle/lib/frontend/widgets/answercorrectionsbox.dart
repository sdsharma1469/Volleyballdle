import 'package:flutter/material.dart';

class AnswerCorrectionsBox extends StatelessWidget {
  final Map<String, String> comparisonResults;

  const AnswerCorrectionsBox({Key? key, required this.comparisonResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: comparisonResults.entries.map((entry) {
        final field = entry.key;
        final result = entry.value;
        Color boxColor;
        String displayText;

        switch (result) {
          case 'Correct':
            boxColor = Colors.green;
            displayText = field; // Display the guessed field (e.g., Japanese)
            break;
          case 'Wrong':
            boxColor = Colors.red;
            displayText = 'Wrong';
            break;
          case 'Higher':
            boxColor = Colors.red;
            displayText = 'Higher';
            break;
          case 'Lower':
            boxColor = Colors.red;
            displayText = 'Lower';
            break;
          default:
            boxColor = Colors.grey; // Fallback for unexpected cases
            displayText = 'Unknown';
        }

        return SizedBox(
          width: 120, // Fixed width for each box
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center( // Center the text inside the container
              child: Text(
                displayText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Ensure text is centered
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
