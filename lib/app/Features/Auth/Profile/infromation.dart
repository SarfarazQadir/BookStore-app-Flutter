import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Welcome to [HABIR]!\n\nDiscover a world of books at your fingertips. From gripping thrillers to heartwarming romances, our app is your gateway to the stories you love and the knowledge you seek. Whether you're an avid reader or just starting your literary journey, we have something special for everyone.\n\nOur mission is to make reading more accessible and enjoyable by bringing your favorite books directly to your device. We are committed to creating a seamless and engaging experience, combining cutting-edge technology with a passion for books.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Text(
              "Our Features",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "- Explore Categories: Easily find books in categories like Horror, Romance, Business, and more.\n"
              "- Personalized Recommendations: Receive book suggestions tailored to your reading preferences.\n"
              "- Favorite List: Save your must-read books to revisit anytime.\n"
              "- Add to Cart: Shop effortlessly by adding books to your cart and checking out in just a few clicks.\n"
              "- Book Reviews: Share your thoughts and read reviews from other readers.\n"
              "- Author Spotlights: Learn more about your favorite authors and their works.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Text(
              "Our Policies",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Privacy Policy:\n"
              "We value your privacy and ensure that your personal information is secure. Any data you share, such as your email address or payment details, is used solely for providing you with the best experience possible.\n\n"
              "Return & Refund Policy:\n"
              "Not satisfied with your purchase? We offer a 7-day return and refund policy for eligible books. Digital products may have restrictions, so please check the terms before purchasing.\n\n"
              "User Conduct:\n"
              "We encourage respectful and honest communication within the app. Any misuse or violation of our policies may result in account suspension.\n\n"
              "Terms of Service:\n"
              "By using our app, you agree to our terms and conditions. Our full terms can be accessed in the settings menu.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Text(
              "Why Choose Us?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "At [Your App Name], we believe that books are more than just pages—they are portals to new worlds. Our app brings you:\n\n"
              "- A user-friendly interface for easy browsing.\n"
              "- Curated collections that cater to all ages and interests.\n"
              "- Exclusive discounts for registered users.\n\n"
              "Join a growing community of book lovers and transform the way you read!",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Got questions or feedback? We're here to help!\n\n"
              "📧 Email: support@[yourappname].com\n"
              "📞 Phone: +123 456 7890",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
