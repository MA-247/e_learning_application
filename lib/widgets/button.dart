import 'package:flutter/material.dart';
import 'package:loading_btn/loading_btn.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isLoading; // Add the isLoading parameter

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false, // Default isLoading to false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap, // Disable onTap while loading
      borderRadius: BorderRadius.circular(12.0),
      splashColor: Colors.blue.shade100, // Color of the ripple effect
      highlightColor: Colors.blue.shade200, // Color of the highlight effect
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 4), // Changes the shadow position
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 18.0,
                width: 18.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white, // Progress indicator color
                ),
              ),
              SizedBox(width: 10), // Space between spinner and text
              Text(
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
              color: Colors.white,
              fontWeight: FontWeight.w600, // Slightly lighter than bold
              fontSize: 18, // Slightly larger font size for better readability
            ),
          ),
        ),
      ),
    );
  }
}
