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
      appBar: AppBar(title: Text('Welcome back, ${user.email}')),
      body: Column(
        children: [
          // Other UI elements
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LearningSection(user: user)),
              );
            },
            child: Text('Learning Section'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizSection(user: user)),
              );
            },
            child: Text('Quiz Section'),
          ),
        ],
      ),
    );
  }
}
