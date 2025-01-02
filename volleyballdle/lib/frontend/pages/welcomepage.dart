import 'package:flutter/material.dart';
import 'package:volleyballdle/backend/player.dart';
import '../frontendfunctions.dart/welcomepagefunctions.dart'; // Refactored functions
import '../widgets/player_details_box.dart';
import '../widgets/user_input_box.dart';
import '../widgets/future_builder_handler.dart';
import '../widgets/answercorrectionsbox.dart';
import 'correctpage.dart';
import '../../backend/user.dart';
import 'userpage.dart'; // Import UserPage for navigation

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isCorrect = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _guessHistory = [];
  UserModel? _user;
  int _guessCount = 0; // Track the number of guesses

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
          leading: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPage(), // Navigate to UserPage
                ),
              );
            },
            tooltip: 'View Your Profile',
          ),
        ),
        body: FutureBuilderHandler<UserModel?>(
          future: getUser(),
          onData: (userData) => _initializeUserAndCheckCompletion(userData),
          loadingMessage: 'Fetching user data...',
          onError: (error) => 'Failed to fetch user data: $error',
        ),
      ),
    );
  }

  Widget _initializeUserAndCheckCompletion(UserModel? userData) {
    _user = userData;
    _checkIfAlreadyCompleted();
    return _buildMainContent();
  }

  void _checkIfAlreadyCompleted() async {
    if (_user == null) return;
    bool hasCompleted = await _user!.hasCompletedQuestionToday();
    if (hasCompleted) {
      goToCorrectPage();
    }
  }

  void goToCorrectPage() async {
    if (_user == null) return;
    String? questionID = await getTodaysQuestionID();
    if (questionID != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorrectPage(
            user: _user!,
            questionId: questionID,
          ),
        ),
      );
    }
  }

  Widget _buildMainContent() {
    return FutureBuilderHandler<Player?>(
      future: getTodaysPlayer(),
      onData: (playerData) => _buildPageContent(playerData),
      loadingMessage: 'Fetching player data...',
      onError: (error) => 'Failed to fetch player data: $error',
    );
  }

  Widget _buildPageContent(Player? playerData) {
    if (playerData == null) {
      return Center(child: Text('No player data available.'));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            _buildGuessCounter(),
            if (_errorMessage.isNotEmpty) _buildErrorMessage(),
            _buildGuessHistory(),
            UserInputBox(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              onSubmit: (firstName, lastName) =>
                  _handleUserInput(playerData, firstName, lastName),
              message: '',
              isCorrect: _isCorrect,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, ${_user?.email ?? 'User'}!',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGuessCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Guess ${_guessCount + 1}/7',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (_guessCount >= 7)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '(Max guesses reached)',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildGuessHistory() {
    return Column(
      children: _guessHistory.map((guess) {
        final player = guess['player'] as Player;
        final comparisonResults = guess['results'] as Map<String, String>;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0), // Add some space between guesses
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 900, // Set the width here
                child: PlayerDetailsBox(player: player),
              ),
              SizedBox(height: 10), // Space between guess and result box
              // Answer corrections box (bottom) with the same width
              SizedBox(
                width: 900, // Set the same width here
                child: AnswerCorrectionsBox(comparisonResults: comparisonResults),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _handleUserInput(
    Player? playerData, String firstName, String lastName) async {
    // Prevent further guesses after 7
    if (_guessCount >= 7) {
      setState(() {
        _errorMessage = 'You have reached the maximum number of guesses.';
      });
      return;
    }

    // Check if the user has already guessed this player
    if (_guessHistory.any((guess) {
      final player = guess['player'] as Player;
      return player.firstName == firstName && player.lastName == lastName;
    })) {
      setState(() {
        _isCorrect = false;
        _errorMessage = 'You\'ve already guessed this player!';
      });
      return; // Return early if the player was already guessed
    }

    Player? playerByName = await getPlayerByName(firstName, lastName);
    Map<String, String> comparisonResults;

    if (playerData == null) {
      setState(() {
        _isCorrect = false;
        _errorMessage = 'Player data is missing, try again later.';
      });
      return;
    }

    if (playerByName == null) {
      setState(() {
        _isCorrect = false;
        _errorMessage = 'No player found by that name, try again!';
      });
      return;
    }

    comparisonResults = comparePlayers(playerData, playerByName);

    setState(() {
      _guessHistory.add({
        'player': playerByName,
        'results': comparisonResults,
      });
      _guessCount++;

      _isCorrect = !comparisonResults.values.contains('Wrong') &&
          !comparisonResults.values.contains('Higher') &&
          !comparisonResults.values.contains('Lower');

      _errorMessage = '';
    });

    if (_isCorrect) {
      goToCorrectPage();
    }
  }
}
