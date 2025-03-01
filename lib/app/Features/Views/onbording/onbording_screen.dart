import 'package:bookapp/app/Constants/colors.dart';
import 'package:bookapp/app/Constants/images.dart';
import 'package:bookapp/app/Constants/text.dart';
import 'package:bookapp/app/Features/Models/model_onbording.dart';
import 'package:bookapp/app/Features/Views/onbording/onboarding_widget.dart';
import 'package:bookapp/app/Features/Views/welcome/welcome_screen.dart'; // Import WelcomeScreen here
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final LiquidController controller = LiquidController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pages = [
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: bonBoardingImage3,
          title: tonBoardingTitle1,
          subTitle: tonBoardingSubTitle1,
          counterText: tonBoardingCounter1,
          bgColor: bOnbordingPage1Color,
          height: size.height,
        ),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: bonBoardingImage2,
          title: tonBoardingTitle2,
          subTitle: tonBoardingSubTitle2,
          counterText: tonBoardingCounter2,
          bgColor: bOnbordingPage2Color,
          height: size.height,
        ),
      ),
      OnBoardingPageWidget(
        model: OnBoardingModel(
          image: bonBoardingImage1,
          title: tonBoardingTitle3,
          subTitle: tonBoardingSubTitles,
          counterText: tonBoardingCounter3,
          bgColor: bOnbordingPage3Color,
          height: size.height,
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: pages,
            liquidController: controller,
            onPageChangeCallback: onPageChangedCallback,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            enableSideReveal: true,
          ),
          Positioned(
            bottom: 60.0,
            child: OutlinedButton(
              onPressed: () {
                int nextPage = controller.currentPage + 1;
                controller.animateToPage(page: nextPage);
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black26),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                foregroundColor: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xff272727),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: 11,
            child: AnimatedSmoothIndicator(
              activeIndex: currentPage,
              effect: const WormEffect(
                activeDotColor: Color(0xff272727),
                dotHeight: 4.5,
              ),
              count: pages.length,
            ),
          ),
        ],
      ),
    );
  }

  void onPageChangedCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}
