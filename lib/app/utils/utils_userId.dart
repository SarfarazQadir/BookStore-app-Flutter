// utils.dart
import 'package:shared_preferences/shared_preferences.dart';

Future<int> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId') ?? -1; // Return -1 if not found
}
