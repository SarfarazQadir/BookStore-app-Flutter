import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookapp/app/Features/Models/model_books.dart';
// new
class BookService {
  final String baseUrl =
      "https://your-api-endpoint.com"; // Replace with your API endpoint

  // Fetch books by category
  Future<List<Book>> fetchBooksByCategory(String category) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/books?category=$category'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load books");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
