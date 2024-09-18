import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isLoading;
  final Color primaryColor; // Main color for gradient and ripple
  final Color secondaryColor; // Second color for gradient
  final Color textColor; // Text color
  final Color rippleColor; // Ripple and highlight color

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
    required this.primaryColor, // Required color customization
    required this.secondaryColor,
    required this.textColor,
    required this.rippleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap, // Disable onTap while loading
      borderRadius: BorderRadius.circular(12.0),
      splashColor: rippleColor.withOpacity(0.2), // Ripple effect color
      highlightColor: rippleColor.withOpacity(0.3), // Highlight effect
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor, // Top color for gradient
              secondaryColor, // Bottom color for gradient
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 18.0,
                width: 18.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white, // Progress indicator color
                ),
              ),
              const SizedBox(width: 10), // Space between spinner and text
              const Text(
                'Signing In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          )
              : Text(
            text,
            style: TextStyle(
              color: textColor, // Custom text color
              fontWeight: FontWeight.w600, // Font weight
              fontSize: 18, // Font size
            ),
          ),
        ),
      ),
    );
  }
}
