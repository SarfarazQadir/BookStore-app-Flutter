import 'dart:convert';
import 'package:bookapp/app/Features/Models/model_books.dart';
import 'package:bookapp/app/Features/Views/Dashboard/bookDetial.dart';
import 'package:bookapp/app/Features/Views/widgets/FooterWidget.dart';
import 'package:bookapp/app/Features/Views/widgets/SearchBoxWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class CategoryBooksPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  CategoryBooksPage({required this.categoryId, required this.categoryName});

  @override
  _CategoryBooksPageState createState() => _CategoryBooksPageState();
}

class _CategoryBooksPageState extends State<CategoryBooksPage> {
  List<Book> books = [];
  bool isLoading = true;
  bool hasBooks = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.100.19:80/bookstore/showBooks.php?category_id=${widget.categoryId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          final booksData = json.decode(response.body) as List;
          books = booksData.map((book) => Book.fromJson(book)).toList();
          isLoading = false;
          hasBooks = books.isNotEmpty;
        });
      } else {
        setState(() {
          isLoading = false;
          hasBooks = false;
        });
      }
    } catch (e) {
      print("Error fetching books: $e");
      setState(() {
        isLoading = false;
        hasBooks = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
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
                  : hasBooks
                      ? ListView.builder(
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
                        )
                      : Center(
                          child: Text(
                            'No books available in this category.',
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 81, 81, 81)),
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}
