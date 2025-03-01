import 'package:get/get.dart';
import 'package:bookapp/app/Features/Views/onbording/onbording_screen.dart';

class SplashScreenController extends GetxController {
  Future<void> startSplash() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    Get.to(() => const OnBoardingScreen(), transition: Transition.fadeIn);
  }
}
