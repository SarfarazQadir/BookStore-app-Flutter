import 'package:bookapp/app/Features/Views/widgets/SearchBoxWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List _favorites = []; // Stores favorite books
  bool isLoading = true; // Tracks loading state
  String errorMessage = ''; // Stores error messages, if any

  @override
  void initState() {
    super.initState();
    fetchFavoriteBooks();
  }

  Future<void> fetchFavoriteBooks() async {
    try {
      // Get user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');

      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = "User not logged in.";
        });
        return;
      }

      // Make a POST request to fetch favorite books
      final response = await http.post(
        Uri.parse('http://192.168.100.19:80/bookstore/get_favorites.php'),
        body: {'userId': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          setState(() {
            _favorites = data['favorites'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? "An unknown error occurred.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              "Failed to load favorite books. Status: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  Future<void> removeFavorite(int bookId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');

      if (userId == null) {
        throw "User not logged in.";
      }

      final response = await http.post(
        Uri.parse('http://192.168.100.19:80/bookstore/deletefavorite.php'),
        body: {
          'userId': userId.toString(),
          'bookId': bookId.toString(),
        },
      );

      final data = json.decode(response.body);

      if (!(response.statusCode == 200 && data['success'])) {
        throw data['message'] ?? "Failed to remove from favorites.";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Favorites")),
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
                  : _favorites.isEmpty
                      ? Center(
                          child: Text(
                            "No favorites yet.",
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 81, 81, 81)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _favorites.length,
                          itemBuilder: (context, index) {
                            final book = _favorites[index];

                            return Dismissible(
                              key: Key(book['book_id'].toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                int bookId = book['book_id'];

                                // Temporarily store the removed item
                                final removedBook = _favorites[index];

                                setState(() {
                                  _favorites.removeAt(index); // Remove locally
                                });

                                // Attempt to remove from backend
                                try {
                                  await removeFavorite(bookId);
                                } catch (e) {
                                  // If an error occurs, restore the item
                                  setState(() {
                                    _favorites.insert(index, removedBook);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Failed to remove favorite: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              background: Container(
                                color:
                                    Colors.redAccent, // Accent color for swipe
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Add navigation logic to the details screen if needed
                                },
                                child: Card(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15), // Rounded corners
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          book['image'],
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(Icons.error,
                                                  color: Colors.red),
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                book['title'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                book['description'] ??
                                                    "No description available",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating: double
                                                                .tryParse(book[
                                                                    'rating']) ??
                                                            0,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 16,
                                                        ignoreGestures: true,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {},
                                                      ),
                                                      Text(
                                                        '${book['rating'] ?? "0"}',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '\$${book['price'] ?? "N/A"}',
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
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
