import 'package:bookapp/app/Features/Views/widgets/BookWidget.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/app/Features/Models/model_books.dart';

Widget BookSliderWidget(List<Book> books, BuildContext context) {
  List<Widget> contents = [];
  for (Book book in books) {
    contents.add(BookWidget(book, context));
    contents.add(SizedBox(width: 20.0));
  }
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: contents,
    ),
  );
}
