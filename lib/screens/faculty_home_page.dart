import 'package:flutter/material.dart';

class FacultyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Page'),
      ),
      body: Center(
        child: Text(
          'This is the faculty page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
