import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/result_page.dart';

class TestPage extends StatefulWidget {
  final String testId;

  TestPage({required this.testId});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Future<List<dynamic>> _testData;
  Map<String, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _testData = _fetchTest();
  }

  Future<void> _submitTest() async {
    try {
      int totalScore = 0;
      final responses = _answers.map((question, answer) {
        return MapEntry(question, answer);
      });

      final testDoc = await FirebaseFirestore.instance.collection('tests').doc(widget.testId).get();
      if (testDoc.exists) {
        final fields = List.from(testDoc.data()!['fields'] ?? []);

        for (var field in fields) {
          if (field['type'] == 'mcq') {
            String correctOption = field['correctOption'];
            String selectedOption = _answers[field['question']] ?? '';
            print('Question: ${field['question']}');
            print('Selected Option: $selectedOption');
            print('Correct Option: $correctOption');
            if (selectedOption == correctOption) {
              totalScore += field['score'] as int? ?? 0;
            }
          }
        }
      }

      await FirebaseFirestore.instance.collection('student_responses').add({
        'testId': widget.testId,
        'responses': responses,
        'score': totalScore,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(score: totalScore)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit test: $e')));
    }
  }


  Future<List<dynamic>> _fetchTest() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('tests').doc(widget.testId).get();
      if (doc.exists) {
        final fields = List.from(doc.data()!['fields'] ?? []);
        print('Fetched fields: $fields'); // Debugging line
        return fields;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching test: $e'); // Debugging line
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        backgroundColor: Colors.blue[300],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _testData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No test data available.'));
          } else {
            final fields = snapshot.data!;
            return ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return _buildField(field);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitTest,
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> field) {
    switch (field['type']) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(field['content'] ?? ''),
        );
      case 'heading':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            field['content'] ?? '',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      case 'image':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(field['url']),
        );
      case 'mcq':
        return _buildMCQField(field);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildMCQField(Map<String, dynamic> field) {
    final options = List<String>.from(field['options'] ?? []);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(field['question'] ?? 'Question'),
        subtitle: Column(
          children: [
            ...List.generate(options.length, (index) {
              return RadioListTile(
                title: Text(options[index]),
                value: options[index],
                groupValue: _answers[field['question']],
                onChanged: (value) {
                  setState(() {
                    _answers[field['question']] = value;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
