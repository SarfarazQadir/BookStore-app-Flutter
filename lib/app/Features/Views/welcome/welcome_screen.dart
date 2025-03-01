import 'package:bookapp/app/Constants/colors.dart';
import 'package:bookapp/app/Constants/images.dart';
import 'package:bookapp/app/Constants/size.dart';
import 'package:bookapp/app/Constants/text.dart';
import 'package:bookapp/app/Features/Auth/login/login_screen.dart';
import 'package:bookapp/app/Features/Auth/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(bWelcomeImage1),
              height: height * 0.5,
            ),
            Column(
              children: [
                Text(
                  tWelComeTitle,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  tWelComeSubTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 15.0),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () => Get.to(() => const LoginScreen()),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: bSecondaryColor,
                          side: BorderSide(color: bSecondaryColor),
                          padding:
                              EdgeInsets.symmetric(vertical: tButtonHeight)),
                      child: Text(tLogin.toUpperCase())),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => Get.to(() => const SignUpScreen()),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: bdarkColor,
                          backgroundColor: bPrimaryColor,
                          side: BorderSide(color: bPrimaryColor),
                          padding:
                              EdgeInsets.symmetric(vertical: tButtonHeight)),
                      child: Text(tSignup.toUpperCase())),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
