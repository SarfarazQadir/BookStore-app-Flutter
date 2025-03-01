import 'package:flutter/material.dart';

class ReviewForm extends StatelessWidget {
  final void Function(String review) onSubmit;

  const ReviewForm({required this.onSubmit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(labelText: "Write your review..."),
          maxLines: 4,
        ),
        ElevatedButton(
          onPressed: () {
            onSubmit(controller.text);
            controller.clear();
          },
          child: Text("Submit Review"),
        ),
      ],
    );
  }
}
