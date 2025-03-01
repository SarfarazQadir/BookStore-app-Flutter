class CartItem {
  final int cartId;
  final int bookId;
  final String title;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.cartId,
    required this.bookId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  // Factory constructor to create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cart_id'],
      bookId: json['book_id'],
      title: json['title'],
      image: json['image'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  // Method to convert CartItem to JSON (optional for API POST requests)
  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'book_id': bookId,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}
