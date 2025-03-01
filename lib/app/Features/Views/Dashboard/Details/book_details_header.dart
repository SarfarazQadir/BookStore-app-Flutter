import 'package:flutter/material.dart';

class BookDetailsHeader extends StatelessWidget {
  final VoidCallback onBackPressed;

  const BookDetailsHeader({required this.onBackPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 48,
      left: 24,
      child: GestureDetector(
        onTap: onBackPressed,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }
}
