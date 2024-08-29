import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_chapter_details_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentChaptersPage extends StatelessWidget {
  final String topicId;

  StudentChaptersPage({required this.topicId});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth
        .instance.currentUser!.uid; // Get the userId from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            icon: Icon(Icons.checklist),
            tooltip: 'Take Post-Test',
            onPressed: () async {
              // Fetch the post-test ID from the topic document
              final topicDoc = await FirebaseFirestore.instance
                  .collection('topics')
                  .doc(topicId)
                  .get();
              final postTestId = topicDoc['posttestId'];

              if (postTestId != null) {
                // Check if the post-test has already been completed
                final postTestCompleted =
                    await _isTestCompleted(postTestId, userId);

                if (!postTestCompleted) {
                  // Show a warning dialog about the post-test
                  _showPostTestWarning(context, postTestId, userId);
                } else {
                  // Show a message if the post-test is already completed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('You have already completed the post-test.')),
                  );
                }
              } else {
                // Handle case where there is no post-test ID
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('No post-test available for this topic.')),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(topicId)
            .collection('chapters')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var chapters = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              var chapter = chapters[index];
              return ListTile(
                title: Text(chapter['title']),
                subtitle: Text(chapter['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChapterDetailPage(
                        chapterId: chapter.id,
                        topicId: topicId,
                      ),
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

  void _showPostTestWarning(
      BuildContext context, String testId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post-Test Required'),
          content:
              Text('You need to complete the post-test to finish the topic.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Start Post-Test'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestPage(
                        testId: testId, userId: userId, isPreTest: false),
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
