import 'package:flutter/material.dart';
import 'database/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/questions/fetch_requests.dart';
import 'authpage.dart';
import 'welcomepage.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  fetchData();
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
