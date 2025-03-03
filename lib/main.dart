import 'package:bookapp/app/Features/Views/Dashboard/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookapp/app/Features/Views/onbording/onbording_screen.dart';

// new

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Debugging: Log retrieved userId
  print("Retrieved userId: ${prefs.getInt('userId')}");

  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp(this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 500),
      title: 'Bookstore App',
      home: isLoggedIn ? HomeScreen() : OnBoardingScreen(),
    );
  }
}
