import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _suggestionsController = TextEditingController();

  String _userName = '';
  String _userEmail = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from SharedPreferences and your server
  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId'); // Get the userId from SharedPreferences

    if (_userId != null && _userId! > 0) {
      final url = "http://192.168.100.19:80/bookstore/get_user.php";
      try {
        var response = await http.post(Uri.parse(url), body: {
          'userId': _userId.toString(),
        });

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success'] == true) {
            setState(() {
              _userName = data['user']['fname'] ?? "No Name";
              _userEmail = data['user']['useremail'] ?? "No Email";
              _nameController.text = _userName;
              _emailController.text = _userEmail;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to fetch user data')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }

  // Submit the feedback and suggestions
  Future<void> _submitFeedback() async {
    if (_userId == null || _userId! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid user')),
      );
      return;
    }

    String feedback = _feedbackController.text;
    String suggestions = _suggestionsController.text;

    final url = 'http://192.168.100.19:80/bookstore/feedback.php';

    try {
      var response = await http.post(Uri.parse(url), body: {
        'user_id': _userId.toString(),
        'feedback_text': feedback,
        'suggestions_text': suggestions,
      });

      var responseData = jsonDecode(response.body);
      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to submit feedback: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "App Policies",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              SizedBox(height: 10),
              Text(
                "By submitting feedback, you agree to our privacy policy and terms of service. Your feedback will help us improve our services.",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: Text('Name'),
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                enabled: false, 
              ),
              SizedBox(height: 16),

             
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  label: Text('Email'),
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                enabled: false, 
              ),
              SizedBox(height: 16),

          
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  label: Text('Feedback'),
                  prefixIcon: Icon(Icons.feedback),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16),

   
              TextFormField(
                controller: _suggestionsController,
                decoration: const InputDecoration(
                  label: Text('Suggestions'),
                  prefixIcon: Icon(Icons.smart_button),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitFeedback, 
                child: Text("Submit Feedback"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
