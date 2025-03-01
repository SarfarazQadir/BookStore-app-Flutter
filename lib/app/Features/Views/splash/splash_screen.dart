import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bookapp/app/Features/Views/onbording/onbording_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:bookapp/app/Features/Controller/splashscreen_controller.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    final SplashScreenController splashController =
        Get.put(SplashScreenController());

    // Start the splash logic
    splashController.startSplash();

    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/icons/loading.json'),
          // Optional text
        ],
      ),
      nextScreen: const OnBoardingScreen(),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 400,
      backgroundColor: Colors.white,
      duration: 3000,
      curve: Curves.easeInOut,
    );
  }
}
