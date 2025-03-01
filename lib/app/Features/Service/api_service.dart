import 'dart:convert';
import 'package:bookapp/app/Features/Models/model_books.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'http://192.168.100.19:80//bookstore/showBooks.php';

  static Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
