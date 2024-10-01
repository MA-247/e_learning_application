import 'package:flutter/material.dart';

class TestUploadConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Confirmation'),
        backgroundColor: theme.primaryColor, // Use theme's primary color
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100.0,
                color: isDarkMode ? Colors.greenAccent : Colors.green[400], // Adaptive color for success icon
              ),
              SizedBox(height: 20),
              Text(
                'Test has been successfully uploaded!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge!.color, // Use theme's text color
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the home screen
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor, // Use theme's primary color for button
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: isDarkMode ? 6.0 : 3.0, // Slightly different shadow for dark mode
                ),
                child: Text(
                  'Go to Home',
                  style: TextStyle(
                    fontSize: 18, // Slightly larger font for better readability
                    fontWeight: FontWeight.w600, // Semi-bold font for emphasis
                    letterSpacing: 1.2, // Slight letter spacing for improved legibility
                    color: theme.buttonTheme.colorScheme?.onPrimary ?? Colors.white, // Ensure good contrast with the button color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor, // Adapt background color to theme
    );
  }
}
