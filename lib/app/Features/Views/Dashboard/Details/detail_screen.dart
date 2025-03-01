import 'package:bookapp/app/Features/Models/model_books.dart';
import 'package:flutter/material.dart';
import 'book_details_header.dart';
import 'book_description_tab.dart';

class DetailScreen extends StatefulWidget {
  final Book book;

  const DetailScreen({required this.book, Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: widget.book.title,
              child: Image.asset(widget.book.image, fit: BoxFit.cover),
            ),
          ),
          BookDetailsHeader(onBackPressed: () => Navigator.pop(context)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.53,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, spreadRadius: 2, blurRadius: 6)
                ],
              ),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [Tab(text: "Details"), Tab(text: "Reviews")],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BookDescriptionTab(book: widget.book),
                        // BookReviewsTab(book: widget.book),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
