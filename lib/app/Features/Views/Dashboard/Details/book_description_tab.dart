import 'package:bookapp/app/Features/Models/model_books.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookDescriptionTab extends StatelessWidget {
  final Book book;

  const BookDescriptionTab({required this.book, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style:
              GoogleFonts.catamaran(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(book.authorName,
            style: TextStyle(fontSize: 18, color: Colors.grey[700])),
        SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              book.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ),
        ButtonRow(),
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(onPressed: () {}, child: Text("Add To Cart")),
        OutlinedButton(onPressed: () {}, child: Text("Favorite")),
      ],
    );
  }
}
