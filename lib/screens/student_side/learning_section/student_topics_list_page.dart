import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_chapters_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart'; // Import the TestPage
import 'package:firebase_auth/firebase_auth.dart';

class TopicsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid; // Get the userId from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
        backgroundColor: Colors.purple[300], // Changed theme color
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('topics').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.purple[300]));
          }

          var topics = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              var topic = topics[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    topic['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700], // Color to match theme
                    ),
                  ),
                  subtitle: Text(
                    'Tap to view chapters',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () async {
                    // Check if the test has been completed by the user
                    final testId = topic['pretestId'];
                    final testCompleted = await _isTestCompleted(testId, userId);

                    if (!testCompleted) {
                      // Show a warning dialog about the pre-test
                      _showPreTestWarning(context, testId, userId);
                    } else {
                      // If the test is completed, navigate to the StudentChaptersPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentChaptersPage(topicId: topic.id),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _isTestCompleted(String testId, String userId) async {
    // Check if the student has already completed the test
    final querySnapshot = await FirebaseFirestore.instance
        .collection('student_responses')
        .where('testId', isEqualTo: testId)
        .where('userId', isEqualTo: userId) // Filter by userId
        .get();

    // If there's at least one document, the test is considered completed
    return querySnapshot.docs.isNotEmpty;
  }

  void _showPreTestWarning(BuildContext context, String testId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pre-Test Required'),
          content: Text('You need to complete the pre-test before accessing the chapters.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Start Pre-Test'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestPage(testId: testId, userId: userId, isPreTest: true),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
