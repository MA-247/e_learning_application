import 'package:e_learning_application/screens/student_side/student_home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_chapters_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart'; // Import the TestPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart';

class TopicsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid; // Get the userId from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
        backgroundColor: Colors.blue[300],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('topics').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var topics = snapshot.data!.docs;

          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              var topic = topics[index];
              return ListTile(
                title: Text(topic['title']),
                subtitle: Text('placeholder'),
                onTap: () async {
                  // Check if the test has been completed by the user
                  final testId = topic['pretestId'];
                  final testCompleted = await _isTestCompleted(testId, userId);

                  if (!testCompleted) {
                    // If the test is not completed, navigate to the TestPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestPage(testId: testId, userId: userId),
                      ),
                    );
                  } else {
                    // If the test is completed, navigate to the StudentChaptersPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentChaptersPage(topicId: topic.id,),
                      ),
                    );
                  }
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
}
