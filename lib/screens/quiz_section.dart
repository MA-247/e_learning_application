import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/models/quiz.dart';
import 'package:e_learning_application/screens/quiz_detail.dart';

class QuizSection extends StatelessWidget {
  final User user;

  QuizSection({required this.user});

  @override
  Widget build(BuildContext context) {
    // Fetch and display the list of quizzes
    // For simplicity, using static data
    List<Quiz> quizzes = [
      Quiz(id: '1', topicId: '1', questions: [
        Question(
          question: 'What is Flutter?',
          options: ['A framework', 'A library', 'A language'],
          correctOption: 0,
        ),
        // Other questions
      ]),
      // Other quizzes
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Section')),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return ListTile(
            title: Text('Quiz ${quiz.id}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizDetail(quiz: quiz)),
              );
            },
          );
        },
      ),
    );
  }
}
