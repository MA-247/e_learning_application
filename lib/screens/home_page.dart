import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/learning_section.dart';
import 'package:e_learning_application/screens/quiz_section.dart';

class HomePage extends StatelessWidget {
  final User user;

  HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome back, ${user.displayName}',
      style: TextStyle(color: Colors.white),),
        centerTitle: true,
      backgroundColor: Colors.blue[300],),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),

            // Other UI elements
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LearningSection(user: user)),
                );
              },
              child: Text('Learning Section'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        minimumSize: Size(double.infinity, 60),
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[300],
        ),
        alignment: Alignment.center,
        ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizSection(user: user)),
                );
              },
              child: Text('Quiz Section'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
                minimumSize: Size(double.infinity, 60),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300],
                ),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
