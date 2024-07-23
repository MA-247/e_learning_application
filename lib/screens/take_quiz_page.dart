import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TakeQuizPage extends StatefulWidget {
  final String quizId;
  TakeQuizPage({required this.quizId});

  @override
  _TakeQuizPageState createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _quizData;
  List<int> _answers = [];
  bool _alreadyTaken = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  void _loadQuiz() async {
    final quizSnapshot = await _firestore.collection('quizzes').doc(widget.quizId).get();
    final scoreSnapshot = await _firestore.collection('scores').doc(widget.quizId).get();
    final scores = scoreSnapshot.data();

    setState(() {
      _quizData = quizSnapshot.data();
      _answers = List<int>.filled(_quizData!["questions"].length, -1);
      _alreadyTaken = scores != null && scores.containsKey(_auth.currentUser!.uid) && !_quizData!["multipleAttempts"];
    });
  }

  void _submitQuiz() async {
    int score = 0;
    for (int i = 0; i < _quizData!["questions"].length; i++) {
      if (_answers[i] == _quizData!["questions"][i]["correctOption"]) {
        score++;
      }
    }

    final currentUser = _auth.currentUser!.uid;
    final scoreDoc = await _firestore.collection('scores').doc(widget.quizId).get();

    if (scoreDoc.exists) {
      final existingData = scoreDoc.data()!;
      if (existingData.containsKey(currentUser)) {
        existingData[currentUser]['score'] = score;
        existingData[currentUser]['attempts'] = (existingData[currentUser]['attempts'] ?? 0) + 1;
        await _firestore.collection('scores').doc(widget.quizId).update(existingData);
      } else {
        await _firestore.collection('scores').doc(widget.quizId).update({
          currentUser: {"score": score, "attempts": 1}
        });
      }
    } else {
      await _firestore.collection('scores').doc(widget.quizId).set({
        currentUser: {"score": score, "attempts": 1}
      });
    }

    setState(() {
      _score = score;
    });

    // Show score and navigate back to the previous page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('Your score is $_score/${_quizData!["questions"].length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to the quiz list page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_quizData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Take Quiz'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_alreadyTaken) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_quizData!["title"]),
        ),
        body: Center(
          child: Text('You have already taken this quiz.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_quizData!["title"]),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitQuiz,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _quizData!["questions"].length,
          itemBuilder: (context, index) {
            final question = _quizData!["questions"][index];
            return Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question["question"], style: TextStyle(fontSize: 18)),
                    for (int i = 0; i < question["options"].length; i++)
                      RadioListTile(
                        title: Text(question["options"][i]),
                        value: i,
                        groupValue: _answers[index],
                        onChanged: (value) {
                          setState(() {
                            _answers[index] = value!;
                          });
                        },
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
