import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid; // Get the userId

    return Scaffold(
      appBar: AppBar(
        title: Text('Test List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal, // Consistent color across the app
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No tests available.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            final tests = snapshot.data!.docs;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                return _buildTestCard(context, test, index, userId);
              },
            );
          }
        },
      ),
    );
  }

  // Helper method to build each test card
  Widget _buildTestCard(BuildContext context, QueryDocumentSnapshot test, int index, String userId) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Text(
            "Test ${index + 1}: ${test['title'] ?? 'No Title'}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
          ),
          subtitle: Text(
            'Tap to take the test',
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.teal),
          onTap: () async {
            final testId = test.id;
            final testCompleted = await _isTestCompleted(testId, userId);

            if (!testCompleted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestPage(
                    testId: testId,
                    userId: userId,
                    isPreTest: false,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You have already completed this test.'),
                  backgroundColor: Colors.teal.shade700,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _isTestCompleted(String testId, String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('student_responses')
        .where('testId', isEqualTo: testId)
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
