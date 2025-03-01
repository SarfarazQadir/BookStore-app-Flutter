import 'dart:convert';

import 'package:bookapp/app/Constants/colors.dart';
import 'package:bookapp/app/Constants/size.dart';
import 'package:bookapp/app/Constants/text.dart';
import 'package:bookapp/app/Features/Auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // TextEditingControllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Submit form data to PHP API
  Future<void> _registerUser() async {
    final url = Uri.parse('http://192.168.100.19:80/bookstore/register.php');
    final response = await http.post(
      url,
      body: {
        'fname': _nameController.text,
        'email': _emailController.text,
        'pnumber': _phoneController.text,
        'password': _passwordController.text,
        'address': _addressController.text, 
        'submit': 'true',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['done'] == "true") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        // Redirect or perform further actions
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Registration Failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: ${response.statusCode}')),
      );
    }
  }

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: tFullName,
                prefixIcon: Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: tFormHeight - 20),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: tEmail,
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: tFormHeight - 20),

            IntlPhoneField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: tPhoneNo,
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                counterText: "",
              ),
              initialCountryCode: 'PK',
              onChanged: (phone) {
                print(phone.completeNumber);
              },
              validator: (value) {
                if (value == null || value.number.length != 11) {
                  return 'Please enter a valid 11-digit phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: tFormHeight - 20),

            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address', // Change to the appropriate label
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),

            // Password Field
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: tPassword,
                prefixIcon: const Icon(Icons.fingerprint),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
              validator: _validatePassword,
            ),
            const SizedBox(height: tFormHeight - 10),

            // Sign-Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bPrimaryColor,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Call the user registration function
                    _registerUser();

                    // After the user is registered, navigate to the LoginScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );

                    // Optional: Show a confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign-up successful!'),
                        backgroundColor:
                            bPrimaryColor, // Adjust color if needed
                      ),
                    );
                  }
                },
                child: Text(
                  tSignup.toUpperCase(),
                  style: TextStyle(color: bdarkColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
