import 'dart:convert';
import 'package:bookapp/app/Constants/colors.dart';
import 'package:bookapp/app/Features/Views/Dashboard/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:bookapp/app/Features/Models/model_cart.dart';
import 'package:bookapp/app/utils/utils_userId.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  bool isLoading = true;
  double totalAmount = 0.0;
  final double shippingFee = 1.50;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  // Fetch Cart

  Future<void> _fetchCartItems() async {
    final userId = await getUserId();

    if (userId == null) {
      print('User is not logged in');
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.100.19:80/bookstore/showCart.php?user_id=$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          cartItems = responseData
              .map((item) => CartItem.fromJson(item))
              .toList(); // Map the response to CartItem model
          totalAmount = _calculateTotal();
          isLoading = false;
        });
      } else {
        setState(() {
          cartItems = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching cart items: $e");
      setState(() {
        cartItems = [];
        isLoading = false;
      });
    }
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> _updateQuantity(CartItem cartItem, int change) async {
    final newQuantity = cartItem.quantity + change;

    if (newQuantity < 1) return;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.19:80/bookstore/updateQuantity.php'),
        headers: {'Content-Type': 'application/json'}, // Add headers
        body: json.encode({
          'cart_id': cartItem.cartId,
          'quantity': newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            final index = cartItems.indexWhere(
              (item) => item.cartId == cartItem.cartId,
            );

            if (index != -1) {
              cartItems[index].quantity = newQuantity; // Update the quantity
              totalAmount = _calculateTotal(); // Recalculate total
            }
          });
        } else {
          print("Server error: ${responseData['message']}");
        }
      } else {
        print("Failed to update quantity. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  Future<void> _removeFromCart(int cartId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://192.168.100.19:80/bookstore/deletecartItem.php?cart_id=$cartId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _fetchCartItems();
        });
      }
    } catch (e) {
      print("Error removing item from cart: $e");
    }
  }

// Add Order

  Future<void> _createOrder() async {
    final userId = await getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please log in to place an order!'),
      ));
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.100.19:80/bookstore/createOrder.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'total_amount': totalAmount,
        'shipping_fee': shippingFee,
        'cart_items': cartItems
            .map((item) => {
                  'book_id': item.bookId,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
      }),
    );

    try {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          cartItems.clear();
          totalAmount = 0.0;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Order placed successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to place order!'),
        ));
      }
    } catch (e) {
      print("Error decoding response: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        leading: IconButton(
            onPressed: () {
              Get.to(HomeScreen());
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : cartItems.isEmpty
                ? Center(child: Text('Your cart is empty.'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            var cartItem = cartItems[index];
                            return Dismissible(
                              key: ValueKey(cartItem.cartId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(
                                      0.5), // Set the background color here
                                  borderRadius: BorderRadius.circular(
                                      15), // Rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: Icon(
                                    LineAwesomeIcons
                                        .trash_alt_solid, // Using LineAwesomeIcons delete icon
                                    color: Colors.white,
                                    size: 30, // Adjust the size of the icon
                                  ),
                                ),
                              ),
                              onDismissed: (direction) async {
                                await _removeFromCart(cartItem.cartId);
                                setState(() {
                                  cartItems.removeAt(
                                      index); // Remove the item from the list
                                });
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Image
                                      Image.network(
                                        'http://192.168.100.19:80/bookstore/${cartItem.image}',
                                        width: 50,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10),
                                      // Title, subtitle, and price
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Nice and awesome book",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '\$${cartItem.price}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Quantity controls
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              _updateQuantity(cartItem, -1);
                                            },
                                          ),
                                          Text('${cartItem.quantity}'),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              _updateQuantity(cartItem, 1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal: \$${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent),
                            ),
                            Text(
                              'Delivery: \$${shippingFee.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: \$${(totalAmount + shippingFee).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bPrimaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _createOrder,
                              child: Text(
                                'Confirm Order',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 40, 40, 40),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
