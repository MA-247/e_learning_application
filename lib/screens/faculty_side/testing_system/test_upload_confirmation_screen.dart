import 'package:flutter/material.dart';

class TestUploadConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Confirmation'),
        backgroundColor: Colors.blue[400], // Slightly different shade for a fresher look
        elevation: 4.0, // Add elevation for a subtle shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for better spacing
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100.0,
                color: Colors.green[400], // Green check icon for success
              ),
              SizedBox(height: 20),
              Text(
                'Test has been successfully uploaded!',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Darker text for better readability
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the home screen
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[500], // Matching button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                ),
                child: Text(
                  'Go to Home',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
