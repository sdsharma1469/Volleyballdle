import 'package:flutter/material.dart';
import 'package:volleyballdle/backend/player.dart';
import '../../backend/useful_functions.dart';
import '../widgets/player_details_box.dart';
import '../widgets/user_input_box.dart';
import '../widgets/future_builder_handler.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final UsefulFunctions _functions = UsefulFunctions();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String _message = '';
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome Page'),
        ),
        body: FutureBuilderHandler<String>(
          future: _functions.getUsername(),
          onData: (username) => FutureBuilderHandler<Player?>(
            future: _functions.getTodaysPlayer(),
            onData: (playerData) {
              if (playerData == null) {
                return Center(child: Text('No player data available.'));
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, $username!',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    PlayerDetailsBox(player: playerData),
                    SizedBox(height: 20),
                    UserInputBox(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      onSubmit: (firstName, lastName) async { // Make this async
                        Player? playerByName = await _functions.getPlayerByName(firstName, lastName); // Fetch the player
                        _functions.checkAnswerPlayerToPlayer(playerData, playerByName, (message, isCorrect) {
                          setState(() {
                            _message = message;
                            _isCorrect = isCorrect;
                          });
                        });
                      },
                      message: _message,
                      isCorrect: _isCorrect,
                    ),
                  ],
                ),
              );
            },
            onError: (error) => 'Failed to fetch player data. Try again later.',
          ),
          onError: (error) => 'Failed to fetch username. Try again later.',
        ),
      ),
    );
  }
}
