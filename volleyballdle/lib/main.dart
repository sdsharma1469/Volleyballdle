import 'package:flutter/material.dart';
import 'database/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'frontend/authpage.dart';
import 'frontend/welcomepage.dart';
import 'database/questions/fetch_questions.dart';
import 'backend/player.dart';
import 'database/questions/populatedb.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  populateDB();
  Player? todaysPlayer = await fetchTodaysPlayer();
  if(todaysPlayer!=null) { todaysPlayer.printPlayerDetails();}
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => AuthPage(),
        '/welcome': (context) => WelcomePage(),
      },
      title: 'Volleyballdle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
