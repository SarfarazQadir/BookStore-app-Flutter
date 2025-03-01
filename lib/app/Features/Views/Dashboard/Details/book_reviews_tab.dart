// import 'package:bookapp/app/Features/Models/model_books.dart';
// import 'package:flutter/material.dart';
// import 'review_list.dart';
// import 'review_form.dart';

// class BookReviewsTab extends StatefulWidget {
//   final Book book;

//   const BookReviewsTab({required this.book, Key? key}) : super(key: key);

//   @override
//   _BookReviewsTabState createState() => _BookReviewsTabState();
// }

// class _BookReviewsTabState extends State<BookReviewsTab> {
//   bool isReviewing = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(child: ReviewList(book: widget.book)),
//         isReviewing
//             ? ReviewForm(onSubmit: (review) {
//                 setState(() => isReviewing = false);
//                 // Handle review submission logic here
//               })
//             : ElevatedButton(
//                 onPressed: () => setState(() => isReviewing = true),
//                 child: Text("Add a Review"),
//               ),
//       ],
//     );
//   }
// }
