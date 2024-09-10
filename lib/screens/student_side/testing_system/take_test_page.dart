import 'package:e_learning_application/screens/student_side/learning_section/student_topics_list_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/student_side/testing_system/result_page.dart';

class TestPage extends StatefulWidget {
  final String testId;
  final String userId;
  final bool isPreTest;

  TestPage({required this.testId, required this.userId, required this.isPreTest});

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
            if (selectedOption == correctOption) {
              totalScore += field['score'] as int? ?? 0;
            }
          }
        }
      }

      await FirebaseFirestore.instance.collection('student_responses').add({
        'testId': widget.testId,
        'userId': widget.userId,
        'responses': responses,
        'score': totalScore,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (widget.isPreTest) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TopicsListPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(score: totalScore),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit test: $e')),
      );
    }
  }

  Future<List<dynamic>> _fetchTest() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('tests').doc(widget.testId).get();
      if (doc.exists) {
        final fields = List.from(doc.data()!['fields'] ?? []);
        return fields;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching test: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _testData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No test data available.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            final fields = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return _buildField(field);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitTest,
        label: Text('Submit'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> field) {
    switch (field['type']) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            field['content'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
        );
      case 'heading':
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            field['content'] ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
          ),
        );
      case 'image':
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(field['url']),
          ),
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
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field['question'] ?? 'Question',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            ...options.map((option) {
              return RadioListTile(
                title: Text(option),
                value: option,
                groupValue: _answers[field['question']],
                onChanged: (value) {
                  setState(() {
                    _answers[field['question']] = value;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
