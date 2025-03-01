import 'package:bookapp/app/Features/Auth/Profile/favoriteScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        "BookStore",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: const Color.fromARGB(150, 247, 0, 58),
                ),
                onPressed: () {
                  // Navigate to FavoritesScreen
                  Get.to(() => FavoritesScreen());
                },
              ),
              const SizedBox(width: 15.0),
              Icon(Icons.notifications, color: Colors.black45),
            ],
          ),
        ),
      ],
    );
  }
}
