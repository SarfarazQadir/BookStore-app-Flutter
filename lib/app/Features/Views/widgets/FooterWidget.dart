import 'package:bookapp/app/Constants/colors.dart';
import 'package:bookapp/app/Features/Auth/Profile/profile_screen.dart';
import 'package:bookapp/app/Features/Views/Dashboard/AddToCart/CartScreen.dart';
import 'package:bookapp/app/Features/Views/Dashboard/home.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  _FooterWidgetState createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  final Color _accentColor = bPrimaryColor;
  int _selectedIndex = 0; // Track the selected index

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex:
          _selectedIndex, // Set the current index to highlight the selected item
      onTap: (index) {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });

        // Navigate to the appropriate screen based on the selected index
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
        }
      },
      selectedItemColor: _accentColor, // Color of the selected item
      unselectedItemColor: Colors.grey[400], // Color of the unselected items
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          activeIcon: Icon(Icons.book, color: _accentColor),
          label: '',
          tooltip: "This is a Book Page",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          activeIcon: Icon(Icons.shopping_cart, color: _accentColor),
          label: '',
          tooltip: "This is a Cart Page",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          activeIcon: Icon(Icons.account_circle, color: _accentColor),
          label: '',
          tooltip: "This is a Profile Page",
        ),
      ],
    );
  }
}
