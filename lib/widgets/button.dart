import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isLoading;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Access theme colors from the current theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: isLoading ? null : onTap, // Disable onTap while loading
      borderRadius: BorderRadius.circular(12.0),
      splashColor: colorScheme.primary.withOpacity(0.2), // Ripple effect color
      highlightColor: colorScheme.primary.withOpacity(0.3), // Highlight effect
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary, // Top color for gradient
              colorScheme.secondary, // Bottom color for gradient
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
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
              Text(
                'Signing In',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
              : Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary, // Use onPrimary for text color
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
