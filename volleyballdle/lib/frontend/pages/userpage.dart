import 'package:flutter/material.dart';
import '../../backend/user.dart';
import '../../backend/player.dart';
import '../widgets/future_builder_handler.dart';
import '../frontendfunctions.dart/userpagefunctions.dart';
import '../../database/questions/UsefulMethods.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilderHandler<UserModel?>(
        future: getUser(), // Fetch user details
        onData: (userData) {
          if (userData == null) {
            return Center(
              child: Text(
                'No user data available. Please log in.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return _buildUserDetails(userData);
        },
        loadingMessage: 'Loading user data...',
        onError: (error) => 'Failed to fetch user data: $error',
      ),
    );
  }

  Widget _buildUserDetails(UserModel userData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildInfoRow('Email:', userData.email ?? 'Unknown'),
            _buildInfoRow(
              'Last Login:',
              userData.lastLogin != null
                  ? userData.lastLogin.toString()
                  : 'Never logged in',
            ),
            _buildInfoRow(
              'Last Question Completed:',
              userData.lastQuestionCompleted ?? 'None',
            ),
            _buildInfoRow(
              'Current Streak:',
              '${userData.streak} ${userData.streak == 1 ? "day" : "days"}',
            ),
            SizedBox(height: 20),
            Text(
              'Completed Questions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            userData.completedQuestions.isNotEmpty
                ? FutureBuilder<List<String>>(
                    future: _fetchCompletedQuestionNames(userData.completedQuestions),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error loading question names: ${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        );
                      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return _buildQuestionNameList(snapshot.data!);
                      } else {
                        return Text(
                          'No questions completed yet.',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        );
                      }
                    },
                  )
                : Text(
                    'No questions completed yet.',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNameList(List<String> questionNames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: questionNames
          .map(
            (name) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '- $name',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<List<String>> _fetchCompletedQuestionNames(List<String> questionIDs) async {
    List<String> questionNames = [];
    for (String id in questionIDs) {
      Player? player = await getPlayerByID(id); // Fetch player by ID
      if (player != null) {
        questionNames.add('${player.firstName} ${player.lastName}');
      } else {
        questionNames.add('Unknown Player (ID: $id)');
      }
    }
    return questionNames;
  }
}
