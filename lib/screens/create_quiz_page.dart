import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateQuizPage extends StatefulWidget {
  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _titleController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  bool _multipleAttempts = true;

  final _firestore = FirebaseFirestore.instance;

  void _addQuestion() {
    _questions.add({
      "question": TextEditingController(),
      "options": [
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController()
      ],
      "correctOption": 0
    });
    setState(() {});
  }

  void _saveQuiz() async {
    final quizData = {
      "title": _titleController.text,
      "multipleAttempts": _multipleAttempts,
      "questions": _questions.map((q) {
        return {
          "question": q["question"].text,
          "options": q["options"].map((opt) => opt.text).toList(),
          "correctOption": q["correctOption"]
        };
      }).toList()
    };

    await _firestore.collection('quizzes').add(quizData);

    // Show dialog and navigate back
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Created'),
        content: Text('The quiz has been created successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveQuiz,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Quiz Title'),
            ),
            SwitchListTile(
              title: Text('Allow Multiple Attempts'),
              value: _multipleAttempts,
              onChanged: (value) {
                setState(() {
                  _multipleAttempts = value;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(index);
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Add Question'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: question["question"],
              decoration: InputDecoration(labelText: 'Question'),
            ),
            for (int i = 0; i < question["options"].length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: question["options"][i],
                      decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                    ),
                  ),
                  Radio(
                    value: i,
                    groupValue: question["correctOption"],
                    onChanged: (value) {
                      setState(() {
                        question["correctOption"] = value!;
                      });
                    },
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
