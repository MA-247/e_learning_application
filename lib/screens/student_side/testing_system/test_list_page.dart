import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth to get the userId

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid; // Get the userId from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        title: Text('Test List'),
        backgroundColor: Colors.blue[300],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tests available.'));
          } else {
            final tests = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                return ListTile(
                  title: Text("Test " + index.toString() ?? 'No title'),
                  onTap: () async {
                    final testId = test.id;
                    final testCompleted = await _isTestCompleted(testId, userId);

                    if (!testCompleted) {
                      // Navigate to TestPage if the test is not completed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPage(testId: testId, userId: userId),
                        ),
                      );
                    } else {
                      // Show a message if the test is already completed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You have already completed this test.')),
                      );
                    }
                  },
                );
              },
            );
          }
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
