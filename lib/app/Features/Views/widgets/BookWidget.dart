import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bookapp/app/Features/Views/Dashboard/bookDetial.dart';
import 'package:bookapp/app/Features/Models/model_books.dart';

Widget BookWidget(Book book, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Check if book_id is valid before navigating
      if (book.bookId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Invalid Book ID")),
        );
        return; // Stop navigation if the book ID is invalid
      }

      // Pass the book data to the DetailScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailScreen(book: book), // Pass book object here
        ),
      );
    },
    child: Container(
      width: 100.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(book.image, height: 140.0, fit: BoxFit.cover),
          const SizedBox(height: 10.0),
          Text(
            book.title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5.0),
          // Add Price here
          Text(
            '\$${book.price}', // Escape the dollar sign
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 5.0),
          // Rating bar
          RatingBar.builder(
            initialRating: double.tryParse(book.rating) ?? 0.0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 10,
            ignoreGestures: true,
            itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
        ],
      ),
    ),
  );
}
