import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:e_learning_application/screens/faculty_side/testing_system/edit_test_page.dart';
import 'package:e_learning_application/screens/faculty_side/testing_system/create_test_page.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser; // Get current user

    return Scaffold(
      appBar: AppBar(
        title: Text('Test List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[400], // Different theme color
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tests')
            .where('createdBy.facultyId', isEqualTo: currentUser?.uid) // Filter by current user ID in the nested 'createdBy' map
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late, color: Colors.teal[300], size: 80),
                  SizedBox(height: 20),
                  Text('No tests available.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                ],
              ),
            );
          }

          var tests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tests.length,
            itemBuilder: (context, index) {
              var test = tests[index];
              var testTitle = test['title'] ?? 'Untitled Test'; // Fetch test title, with a fallback

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 6,
                shadowColor: Colors.teal.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.description, color: Colors.teal[300]),
                  title: Text(
                    testTitle, // Display the actual test title
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${test.id}', style: TextStyle(color: Colors.grey[600])),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal[700]),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTestPage(testId: test.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('tests')
                                .doc(test.id)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Test deleted'),
                              backgroundColor: Colors.green,
                            ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to delete test: $e'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTestPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.teal[400],
        tooltip: 'Create New Test',
      ),
    );
  }
}
