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
        title: Text('Test List', style: TextStyle(color: Theme.of(context).appBarTheme.titleTextStyle?.color)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor, // Use primary color or appBar background color from the theme
        elevation: Theme.of(context).appBarTheme.elevation ?? 4.0, // Elevation from the theme
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
            return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Theme.of(context).primaryColor)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late, color: Theme.of(context).primaryColor.withOpacity(0.7), size: 80),
                  SizedBox(height: 20),
                  Text('No tests available.',
                      style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[700])),
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
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.description, color: Theme.of(context).primaryColor.withOpacity(0.7)),
                  title: Text(
                    testTitle, // Display the actual test title
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${test.id}', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600])),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
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
                        icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('tests')
                                .doc(test.id)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Test deleted'),
                              backgroundColor: Theme.of(context).primaryColor,
                            ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to delete test: $e'),
                              backgroundColor: Theme.of(context).primaryColor,
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
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Create New Test',
      ),
    );
  }
}
