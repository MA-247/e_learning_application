import 'package:flutter/material.dart';

class ReviewAnswersPage extends StatelessWidget {
  final Map<String, dynamic> userAnswers;
  final List<Map<String, dynamic>> testQuestions; // List of all the test questions with correct answers

  ReviewAnswersPage({required this.userAnswers, required this.testQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Answers'),
        backgroundColor: Colors.blue[300],
      ),
      body: ListView.builder(
        itemCount: testQuestions.length,
        itemBuilder: (context, index) {
          final question = testQuestions[index];
          final correctAnswer = question['correctOption'];
          final userAnswer = userAnswers[question['question']] ?? '';
          final isCorrect = userAnswer == correctAnswer;

          return Card(
            margin: EdgeInsets.all(10),
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Text
                  Text(
                    question['question'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // User's Answer
                  Text(
                    'Your Answer: $userAnswer',
                    style: TextStyle(
                      fontSize: 16,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),

                  // Correct Answer
                  if (!isCorrect)
                    Text(
                      'Correct Answer: $correctAnswer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
