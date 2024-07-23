import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/take_quiz_page.dart';

class QuizListPage extends StatefulWidget {
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Quizzes'),
      ),
      body: FutureBuilder(
        future: _fetchQuizzes(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final quizzes = snapshot.data!;

          if (quizzes.isEmpty) {
            return Center(child: Text('No quizzes available'));
          }

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return ListTile(
                title: Text(quiz['title']),
                subtitle: Text('Score: ${quiz['score'] ?? 'Not taken yet'}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakeQuizPage(quizId: quiz['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchQuizzes() async {
    final currentUser = _auth.currentUser!;
    final quizSnapshot = await _firestore.collection('quizzes').get();

    List<Map<String, dynamic>> availableQuizzes = [];

    for (var quiz in quizSnapshot.docs) {
      final quizId = quiz.id;
      final quizData = quiz.data() as Map<String, dynamic>;
      final userScore = await _fetchUserScoreForQuiz(currentUser.uid, quizId);
      bool canTakeQuiz = true;

      if (userScore != null && !quizData['multipleAttempts']) {
        canTakeQuiz = false;
      }

      if (canTakeQuiz) {
        availableQuizzes.add({
          'id': quizId,
          'title': quizData['title'],
          'score': userScore,
        });
      }
    }

    return availableQuizzes;
  }

  Future<int?> _fetchUserScoreForQuiz(String userId, String quizId) async {
    final scoresSnapshot = await _firestore.collection('scores').doc(quizId).get();

    if (scoresSnapshot.exists) {
      final scores = scoresSnapshot.data() as Map<String, dynamic>;
      return scores[userId]?['score'] as int?;
    }

    return null;
  }
}
