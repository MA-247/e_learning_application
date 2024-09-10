import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600]), // Slightly darker hint text
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Adjust vertical padding for balance
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Slightly smaller border radius for a more modern look
          borderSide: BorderSide(color: Colors.grey.shade400), // Lighter grey border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0), // Blue border when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade400), // Light grey border when enabled
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0), // Red border when error
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0), // Red border when focused and error
        ),
        prefixIcon: Icon(Icons.text_fields, color: Colors.grey[600]), // Example prefix icon
      ),
    );
  }
}
