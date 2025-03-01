import 'package:bookapp/app/Features/Models/model_books.dart';
import 'package:bookapp/app/Features/Service/api_service.dart';
import 'package:bookapp/app/Features/Views/widgets/BookWidget.dart';
import 'package:flutter/material.dart';

class BookListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
      body: FutureBuilder<List<Book>>(
        future: ApiService.fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookWidget(books[index], context);
              },
            );
          } else {
            return Center(child: Text('No books found.'));
          }
        },
      ),
    );
  }
}
