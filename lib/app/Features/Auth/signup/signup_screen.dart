import 'package:bookapp/app/Constants/images.dart';
import 'package:bookapp/app/Constants/size.dart';
import 'package:bookapp/app/Constants/text.dart';
import 'package:bookapp/app/Features/Auth/signup/form_header_widget.dart';
import 'package:bookapp/app/Features/Auth/signup/signup_footer_widget.dart';
import 'package:bookapp/app/Features/Auth/signup/signup_form_widget.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: const [
                FormHeaderWidget(
                  image: bloginImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  imageHeight: 0.20,
                ),
                SignUpFormWidget(),
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
