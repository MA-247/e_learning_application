import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  title: Text("Test" + index.toString() ?? 'No title'),
                  onTap: () {
                    print("going to test");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestPage(testId: test.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
