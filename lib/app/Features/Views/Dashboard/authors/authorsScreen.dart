import 'dart:convert';
import 'package:bookapp/app/Features/Views/Dashboard/bookDetial.dart';
import 'package:bookapp/app/Features/Views/widgets/FooterWidget.dart';
import 'package:bookapp/app/Features/Views/widgets/SearchBoxWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:bookapp/app/Features/Models/model_books.dart';

class AuthorBooksPage extends StatefulWidget {
  final int authorId;
  final String authorName;

  const AuthorBooksPage({
    Key? key,
    required this.authorId,
    required this.authorName,
  }) : super(key: key);

  @override
  _AuthorBooksPageState createState() => _AuthorBooksPageState();
}

class _AuthorBooksPageState extends State<AuthorBooksPage> {
  List<Book> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooksByAuthor(widget.authorId);
  }

  Future<void> _fetchBooksByAuthor(int authorId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.100.19:80/bookstore/showBooks.php?author_id=$authorId'),
      );

      if (response.statusCode == 200) {
        final booksData = json.decode(response.body) as List;
        setState(() {
          books = booksData.map((book) => Book.fromJson(book)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          books = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching books by author: $e");
      setState(() {
        books = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.authorName)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Box with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SearchBoxWidget(),
            ),
            const SizedBox(height: 25.0), // Space below search box
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : books.isEmpty
                      ? Center(
                          child: Text(
                            'No books found for this author.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            Book book = books[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(book: book),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        book.image,
                                        width: 100,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Book title
                                            Text(
                                              book.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              book.description,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 6),
                                            // Rating and Price row
                                            Row(
                                              children: [
                                                // Rating stars first
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating:
                                                          double.tryParse(book
                                                                      .rating
                                                                  as String) ??
                                                              0,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 16,
                                                      ignoreGestures: true,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0.5),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    ),
                                                    // Rating number below stars
                                                    Text(
                                                      '${book.rating}',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                // Price on the right side
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '\$${book.price}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}
