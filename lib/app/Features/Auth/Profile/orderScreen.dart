import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isLoading = true;
  List<dynamic> orders = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');

      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = "User not logged in.";
        });
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.100.19:80/bookstore/get_orders.php'),
        body: {'userId': userId.toString()},
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          setState(() {
            orders = data['orders'] ?? [];
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
              "Failed to load orders. Status: ${response.statusCode}";
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

  Future<void> cancelOrder(int orderId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in.")),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.100.19:80/bookstore/cancelOrder.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId, 'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
          fetchOrderDetails(); // Refresh the orders after cancellation
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to cancel order.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : orders.isEmpty
                  ? Center(child: Text("No orders found."))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final items = order['items'] as List<dynamic>;
                        final firstItem = items.isNotEmpty ? items[0] : null;

                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Book Image (Rectangle)
                                firstItem != null && firstItem['image'] != null
                                    ? Container(
                                        height: 100,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'http://192.168.100.19:80/bookstore/${firstItem['image']}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ) // Fallback widget if the image is null

                                    : Container(
                                        height: 80,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey[300],
                                        ),
                                        child: Icon(
                                          Icons.book,
                                          size: 40,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                SizedBox(width: 12),
                                // Order Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Book Title
                                      Text(
                                        firstItem != null
                                            ? firstItem['title'] ??
                                                "Unknown Title"
                                            : "Unknown Title",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      // Order Status
                                      Text(
                                        order['status'] == "Delivered"
                                            ? "Delivered on ${order['order_date']}"
                                            : "Status: ${order['status']}",
                                        style: TextStyle(
                                          color: order['status'] == "Delivered"
                                              ? Colors.green
                                              : Colors.orange,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      // Total Amount + Cancel Button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total: \$${order['total_amount']}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              cancelOrder(order['order_id']);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
