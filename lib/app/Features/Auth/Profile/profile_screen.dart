import 'package:bookapp/app/Constants/colors.dart';
import 'package:bookapp/app/Constants/images.dart';
import 'package:bookapp/app/Constants/size.dart';
import 'package:bookapp/app/Constants/text.dart';
import 'package:bookapp/app/Features/Auth/Profile/favoriteScreen.dart';
import 'package:bookapp/app/Features/Auth/Profile/feedback.dart';
import 'package:bookapp/app/Features/Auth/Profile/infromation.dart';
import 'package:bookapp/app/Features/Auth/Profile/orderScreen.dart';
import 'package:bookapp/app/Features/Auth/Profile/updateprofile_screen.dart';
import 'package:bookapp/app/Features/Views/Dashboard/home.dart';
import 'package:bookapp/app/Features/Views/welcome/welcome_screen.dart';
import 'package:bookapp/app/Features/Views/widgets/ProfileMenuWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName = "Loading...";
  String? _userEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null && userId > 0) {
      final url = "http://192.168.100.19:80/bookstore/get_user.php";
      try {
        var response = await http.post(Uri.parse(url), body: {
          'userId': userId.toString(),
        });

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success'] == true) {
            setState(() {
              _userName = data['user']['fname'] ?? "No Name";
              _userEmail = data['user']['email'] ?? "No Email";
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(data['message'] ?? 'Failed to fetch data')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      // If userId is not found, show a message or handle it accordingly.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAll(HomeScreen());
            },
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title:
            Text(tProfile, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage(bUserImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromARGB(255, 69, 62, 62),
                      ),
                      child: const Icon(
                        LineAwesomeIcons.pencil_alt_solid,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Display User Name and Email
              Text(
                _userName ?? "Loading...",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                _userEmail ?? "Loading...",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int? userId = prefs.getInt('userId'); // Retrieve the userId

                    if (userId != null && userId > 0) {
                      // If userId exists, navigate to UpdateProfilePage with the userId
                      Get.to(() => UpdateProfileScreen(userId: userId));
                    } else {
                      // If userId is not found (not logged in), show a message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User not logged in')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 43, 42, 38),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(tEditProfile,
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "My Favorites",
                  icon: LineAwesomeIcons.bookmark,
                  onPress: () {
                    Get.to(() => FavoritesScreen());
                  }),
              ProfileMenuWidget(
                title: "Order History",
                icon: LineAwesomeIcons.history_solid,
                onPress: () {
                  Get.to(() => OrderScreen());
                },
              ),

              ProfileMenuWidget(
                  title: "FeedBack",
                  icon: LineAwesomeIcons.sms_solid,
                  onPress: () {
                    Get.to(() => FeedbackForm());
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Information",
                  icon: LineAwesomeIcons.info_circle_solid,
                  onPress: () {
                    Get.to(() => InformationPage());
                  }),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.sign_out_alt_solid,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  Get.defaultDialog(
                    title: "LOGOUT",
                    titleStyle: const TextStyle(fontSize: 20),
                    content: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text("Are you sure, you want to Logout?"),
                    ),
                    confirm: Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Clear the session data from SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('isLoggedIn'); // Remove the login flag

                          // Optionally, navigate back to the login screen or onboarding
                          Get.offAll(() =>
                              WelcomeScreen()); // Or replace with login screen

                          // Show a confirmation message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Logged out successfully")),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bdarkColor,
                          side: BorderSide.none,
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    cancel: OutlinedButton(
                        onPressed: () => Get.back(), child: const Text("No")),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
