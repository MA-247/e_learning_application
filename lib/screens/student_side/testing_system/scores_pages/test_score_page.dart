import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoresListPage extends StatefulWidget {
  final String topicId;
  final String userId; // Add userId here

  ScoresListPage({required this.topicId, required this.userId}); // Update the constructor

  @override
  _ScoresListPageState createState() => _ScoresListPageState();
}

class _ScoresListPageState extends State<ScoresListPage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scores',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        elevation: Theme.of(context).appBarTheme.elevation ?? 4.0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchScores(widget.topicId, widget.userId), // Pass the userId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No scores available.',
                style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant),
              ),
            );
          } else {
            var data = snapshot.data!;
            bool postTestAvailable = data['postTestAvailable'] as bool;
            int preTestScore = data['preTestScore'] as int;
            int postTestScore = data['postTestScore'] as int;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scores for Topic',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 20),
                  if (postTestAvailable)
                    _buildScoreCard('Pre-Test Score', preTestScore, colorScheme)
                  else
                    Text(
                      'Complete the post-test to view the scores.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  SizedBox(height: 10),
                  if (postTestAvailable)
                    _buildScoreCard('Post-Test Score', postTestScore, colorScheme)
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchScores(String topicId, String userId) async {
    final topicData = await FirebaseFirestore.instance.collection('topics').doc(topicId).get();
    final pretestId = topicData['pretestId'] as String?;
    final posttestId = topicData['posttestId'] as String?;

    bool postTestAvailable = false;
    int preTestScore = 0;
    int postTestScore = 0;

    if (posttestId != null) {
      final postTestResponsesSnapshot = await FirebaseFirestore.instance
          .collection('student_responses')
          .where('testId', isEqualTo: posttestId)
          .where('userId', isEqualTo: userId)
          .get();
      if (postTestResponsesSnapshot.docs.isNotEmpty) {
        postTestAvailable = true;
        postTestScore = postTestResponsesSnapshot.docs.fold(0, (sum, doc) => sum + (doc['score'] as int? ?? 0));
      }
    }

    if (pretestId != null) {
      final preTestResponsesSnapshot = await FirebaseFirestore.instance
          .collection('student_responses')
          .where('testId', isEqualTo: pretestId)
          .where('userId', isEqualTo: userId)
          .get();
      preTestScore = preTestResponsesSnapshot.docs.fold(0, (sum, doc) => sum + (doc['score'] as int? ?? 0));
    }

    return {
      'preTestScore': preTestScore,
      'postTestScore': postTestScore,
      'postTestAvailable': postTestAvailable,
    };
  }

  Widget _buildScoreCard(String title, int score, ColorScheme colorScheme) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          '$score',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
