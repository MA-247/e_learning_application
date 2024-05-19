import 'package:flutter/material.dart';
import 'package:e_learning_application/models/quiz.dart';

class QuizDetail extends StatelessWidget {
  final Quiz quiz;

  QuizDetail({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz ${quiz.id}')),
      body: ListView.builder(
        itemCount: quiz.questions.length,
        itemBuilder: (context, index) {
          final question = quiz.questions[index];
          return ListTile(
            title: Text(question.question),
            // Implement options selection and scoring logic
          );
        },
      ),
    );
  }
}
