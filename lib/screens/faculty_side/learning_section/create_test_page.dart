import 'package:e_learning_application/screens/faculty_side/learning_section/add_chapter_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateTestPage extends StatefulWidget {
  @override
  _CreateTestPageState createState() => _CreateTestPageState();
}

class _CreateTestPageState extends State<CreateTestPage> {
  final _formKey = GlobalKey<FormState>();
  String _testTitle = '';
  bool _isLoading = false;

  // Method to get current user's details
  Future<Map<String, String>> _getFacultyInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('faculty')
          .doc(currentUser.uid)
          .get();
      String name = userDoc['name'];
      String email = currentUser.email!;
      return {'name': name, 'email': email};
    }
    return {'name': 'Unknown', 'email': 'Unknown'};
  }

  Future<void> _createTest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true; // Show loading state
      });

      try {
        // Retrieve faculty info
        Map<String, String> facultyInfo = await _getFacultyInfo();

        await FirebaseFirestore.instance.collection('tests').add({
          'title': _testTitle,
          'createdBy': facultyInfo['name'],
          'creatorEmail': facultyInfo['email'],
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test created successfully!')),
        );

        Navigator.of(context).pop(); // Navigate back or elsewhere
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create test: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading state
        });
      }
    }
  }

  void _navigateToAddChapter() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddChapterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Test Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _testTitle = value!;
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createTest,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal[300],
                  ),
                  child: Text(
                    _isLoading ? 'Creating...' : 'Create Test',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToAddChapter,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue[300],
                  ),
                  child: Text(
                    'Add Chapter',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
