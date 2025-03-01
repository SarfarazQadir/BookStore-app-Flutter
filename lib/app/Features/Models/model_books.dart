class Book {
  final int bookId;
  final String title;
  final String image;
  final String price;
  final String authorName;
  final String authorImage;
  final String categoryName;
  final String rating;
  final String description;

  Book({
    required this.bookId,
    required this.title,
    required this.image,
    required this.price,
    required this.authorName,
    required this.authorImage,
    required this.categoryName,
    required this.rating,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'http://192.168.100.19:80/bookstore/';

    return Book(
      bookId: int.tryParse(json['book_id'].toString()) ??
          0, // Convert book_id to int and fallback to 0 if conversion fails
      title: json['title'] ?? '',
      image: baseUrl + (json['image'] ?? ''),
      price: json['price']?.toString() ?? '0',
      authorName: json['ath_name'] ?? '',
      authorImage: baseUrl + (json['ath_image'] ?? ''),
      categoryName: json['cname'] ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      description: json['description'] ?? '',
    );
  }
}
