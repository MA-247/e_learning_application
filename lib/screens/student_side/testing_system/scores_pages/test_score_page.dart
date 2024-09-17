import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoresListPage extends StatefulWidget {
  final String topicId;

  ScoresListPage({required this.topicId});

  @override
  _ScoresListPageState createState() => _ScoresListPageState();
}

class _ScoresListPageState extends State<ScoresListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _fetchScores(widget.topicId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.redAccent)));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No scores available.', style: TextStyle(fontSize: 18, color: Colors.grey[600])));
          } else {
            var scores = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scores for Topic',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[700]),
                  ),
                  SizedBox(height: 20),
                  _buildScoreCard('Pre-Test Score', scores['preTestScore'] ?? 0),
                  SizedBox(height: 10),
                  _buildScoreCard('Post-Test Score', scores['postTestScore'] ?? 0),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, int>> _fetchScores(String topicId) async {
    final topicData = await FirebaseFirestore.instance.collection('topics').doc(topicId).get();
    final pretestId = topicData['pretestId'] as String?;
    final posttestId = topicData['posttestId'] as String?;

    int preTestScore = 0;
    int postTestScore = 0;

    if (pretestId != null) {
      final preTestResponsesSnapshot = await FirebaseFirestore.instance
          .collection('student_responses')
          .where('testId', isEqualTo: pretestId)
          .get();
      preTestScore = preTestResponsesSnapshot.docs.fold(0, (sum, doc) => sum + (doc['score'] as int? ?? 0));
    }

    if (posttestId != null) {
      final postTestResponsesSnapshot = await FirebaseFirestore.instance
          .collection('student_responses')
          .where('testId', isEqualTo: posttestId)
          .get();
      postTestScore = postTestResponsesSnapshot.docs.fold(0, (sum, doc) => sum + (doc['score'] as int? ?? 0));
    }

    return {
      'preTestScore': preTestScore,
      'postTestScore': postTestScore,
    };
  }

  Widget _buildScoreCard(String title, int score) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[700]),
        ),
        trailing: Text(
          '$score',
          style: TextStyle(fontSize: 18, color: Colors.teal[900]),
        ),
      ),
    );
  }
}
