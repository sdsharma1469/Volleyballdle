import 'package:volleyballdle/backend/player.dart';
import 'package:volleyballdle/backend/useful_functions.dart';
import 'package:volleyballdle/backend/user.dart';

final UsefulFunctions _functions = UsefulFunctions();
Future<UserModel?> getUser() async => _functions.getUser();