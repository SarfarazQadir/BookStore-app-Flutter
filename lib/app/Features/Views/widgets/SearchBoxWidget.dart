import 'package:flutter/material.dart';

Widget SearchBoxWidget() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0), color: Colors.grey[200]),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
        hintText: "Search",
      ),
    ),
  );
}
