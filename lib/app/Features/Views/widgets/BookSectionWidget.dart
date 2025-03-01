import 'package:bookapp/app/Features/Views/widgets/BookSliderWidget.dart';
import 'package:flutter/material.dart';
import '../../Models/model_books.dart';

class BookSectionWidget extends StatelessWidget {
  final String title;
  final List<Book> bookList;
  final BuildContext context;

  BookSectionWidget({
    required this.title,
    required this.bookList,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "See all",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        BookSliderWidget(bookList, context), // Corrected here
        const SizedBox(height: 50.0),
      ],
    );
  }
}
