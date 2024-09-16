import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color textColor; // Added parameter for text color
  final Color fillColor; // Added parameter for fill color

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.textColor,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor), // Apply the text color
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor, // Apply the fill color
        hintText: hintText,
        hintStyle: TextStyle(
          color: textColor.withOpacity(0.7), // Apply text color with opacity for hint text
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: textColor.withOpacity(0.5), // Apply text color with opacity for border
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: colorScheme.primary, // Use theme primary color for focused border
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: textColor.withOpacity(0.5), // Apply text color with opacity for enabled border
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: colorScheme.error, // Use theme error color for error border
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: colorScheme.error, // Use theme error color for focused error border
            width: 2.0,
          ),
        ),
        prefixIcon: Icon(
          Icons.text_fields,
          color: textColor.withOpacity(0.7), // Apply text color with opacity for prefix icon
        ),
      ),
    );
  }
}
