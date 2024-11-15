import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color textColor; // Added parameter for text color
  final Color fillColor; // Added parameter for fill color

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textColor,
    required this.fillColor,
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: TextStyle(color: widget.textColor), // Apply the text color
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor, // Apply the fill color
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.textColor.withOpacity(0.7), // Apply text color with opacity for hint text
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: widget.textColor.withOpacity(0.5), // Apply text color with opacity for border
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
            color: widget.textColor.withOpacity(0.5), // Apply text color with opacity for enabled border
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
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: widget.textColor.withOpacity(0.7), // Apply text color with opacity for suffix icon
          ),
          onPressed: _toggleVisibility,
        ),

      ),
    );
  }
}
