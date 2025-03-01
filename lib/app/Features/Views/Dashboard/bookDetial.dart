import 'dart:convert';

import 'package:bookapp/app/Constants/colors.dart';
import 'package:bookapp/app/Constants/constants.dart';
import 'package:bookapp/app/Features/Models/model_books.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Book book;

  const DetailScreen({required this.book, Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Size size;
  TextEditingController _reviewController = TextEditingController();

  bool _isReviewing = false;
  Future<void> addToCart(String userId, int bookId) async {
    const String apiUrl = "http://192.168.100.19:80/bookstore/addcart.php";

    if (bookId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Book ID")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_id': userId,
          'book_id': bookId.toString(),
          'quantity': '1',
        },
      );

      // Log the raw response for debugging
      print("Raw Response: ${response.body}");

      // Check for a successful HTTP status code
      if (response.statusCode == 200) {
        // Decode JSON safely
        Map<String, dynamic> result;
        try {
          result = jsonDecode(response.body);
        } catch (e) {
          print("Error decoding JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid server response.")),
          );
          return;
        }

        // Check the result for success or error
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Added to cart!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result['message'] ?? "Failed to add to cart.")),
          );
        }
      } else {
        // If the status code is not 200, show an error
        print("HTTP request failed with status: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error. Please try again.")),
        );
      }
    } catch (error) {
      // Catch and display errors
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Check for Book Data Integrity (book_id)
    if (widget.book.bookId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Invalid Book ID")),
      );
      // You can choose to go back to the previous screen or handle it accordingly.
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Go back after a short delay
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Hero(
              tag: widget.book.title,
              child: Image.network(
                widget.book.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Top Buttons (Back Button on Right Side)
          Positioned(
            top: 48,
            left: 24,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: kPrimaryColor),
              ),
            ),
          ),

          // Book Details UI
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.53,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 2,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Title and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.book.title,
                          style: GoogleFonts.catamaran(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "\$${widget.book.price}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.book.authorName,
                    style: GoogleFonts.catamaran(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Rating and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating Stars
                      Row(
                        children: List.generate(5, (index) {
                          double rating =
                              double.tryParse(widget.book.rating) ?? 0.0;
                          return Icon(
                            index < rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: kStarsColor,
                          );
                        }),
                      ),
                      Text(
                        "(${widget.book.rating})",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // TabBar for Detail and Review
                  Container(
                    decoration: BoxDecoration(
                      color: bwhoiteColor,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: GoogleFonts.catamaran(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: "Details"),
                        Tab(text: "Reviews"),
                      ],
                    ),
                  ),

                  // TabBarView for switching between Detail and Review content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Detail Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Detail Scrollable Content
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.book.description,
                                  style: GoogleFonts.catamaran(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                            // Buttons under the Details Section
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Add to Cart Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: bPrimaryColor,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      int? userId = prefs.getInt('userId');
                                      print("Saved User ID: $userId");

                                      if (userId == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text("Please log in first.")),
                                        );
                                        return;
                                      }

                                      int bookId = widget.book.bookId;
                                      print("Book ID: $bookId");

                                      if (bookId <= 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text("Invalid Book ID.")),
                                        );
                                        return;
                                      }

                                      await addToCart(
                                          userId.toString(), bookId);
                                    },
                                    child: Text(
                                      "Add To Cart",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 40, 40, 40),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Favorite Button with Pink Heart Icon
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 45),
                                      backgroundColor: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(color: kPrimaryColor),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      int? userId = prefs.getInt('userId');

                                      if (userId == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text("Please log in first.")),
                                        );
                                        return;
                                      }

                                      int bookId = widget.book.bookId;

                                      // API Call to Add to Favorites
                                      final url =
                                          'http://192.168.100.19:80/bookstore/addfavorites.php';
                                      final response = await http.post(
                                        Uri.parse(url),
                                        body: {
                                          'userId': userId.toString(),
                                          'bookId': bookId.toString(),
                                        },
                                      );

                                      final data = jsonDecode(response.body);

                                      if (data['success']) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Book added to favorites.")),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(data['message'] ??
                                                  "Failed to add to favorites.")),
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Favorite",
                                          style: TextStyle(
                                            color: bwhoiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.favorite_border,
                                          color: bwhoiteColor,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Reviews Content
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Existing Reviews
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    // Author Image
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundImage: AssetImage(''),
                                    ),
                                    SizedBox(width: 12),
                                    // Use Expanded here to prevent overflow
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Username", // Placeholder username
                                            style: GoogleFonts.catamaran(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          // This will wrap text and prevent overflow
                                          Text(
                                            "This is an example review content from the user. This is a longer text that should wrap correctly.",
                                            style: GoogleFonts.catamaran(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                            softWrap: true, // Ensure text wraps
                                            overflow: TextOverflow
                                                .visible, // Allow overflow without cutting off text
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Input to Add a Review (Visible when _isReviewing is true)
                              if (_isReviewing) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextField(
                                    controller: _reviewController,
                                    decoration: InputDecoration(
                                      labelText: "Write your review...",
                                      labelStyle: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                    ),
                                    maxLines: 4,
                                  ),
                                ),
                                // Submit Review Button
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Submit the review here
                                      print(
                                          "Review Submitted: ${_reviewController.text}");
                                      // Clear the input field
                                      _reviewController.clear();
                                      setState(() {
                                        _isReviewing =
                                            false; // Hide the input field after submission
                                      });
                                    },
                                    child: Text(
                                      "Submit Review",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              // Show Add Review Button when not reviewing
                              if (!_isReviewing)
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isReviewing = true;
                                      });
                                    },
                                    child: Text(
                                      "Add a Review",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 25,
            bottom: (size.height * 0.5),
            child: CircleAvatar(
              radius: 35,
              backgroundImage:
                  NetworkImage(widget.book.authorImage), // Use NetworkImage
            ),
          ),
        ],
      ),
    );
  }
}
