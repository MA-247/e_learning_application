import 'package:e_learning_application/screens/student_side/learning_section/learning_section.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart';

class StudentChaptersPage extends StatefulWidget {
  final String topicId;

  StudentChaptersPage({required this.topicId});

  @override
  State<StudentChaptersPage> createState() => _StudentChaptersPageState();
}

class _StudentChaptersPageState extends State<StudentChaptersPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid; // Get the userId from FirebaseAuth

    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
        backgroundColor: Colors.teal[300],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search chapters...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
        ),// Changed theme color
        actions: [
          IconButton(
            icon: Text('Take Test'),
            tooltip: 'Take Post-Test',
            onPressed: () async {
              // Fetch the post-test ID from the topic document
              final topicDoc = await FirebaseFirestore.instance
                  .collection('topics')
                  .doc(widget.topicId)
                  .get();
              final postTestId = topicDoc['posttestId'];

              if (postTestId != null) {
                // Check if the post-test has already been completed
                final postTestCompleted = await _isTestCompleted(postTestId, userId);

                if (!postTestCompleted) {
                  // Show a warning dialog about the post-test
                  _showPostTestWarning(context, postTestId, userId);
                } else {
                  // Show a message if the post-test is already completed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You have already completed the post-test.'),
                    ),
                  );
                }
              } else {
                // Handle case where there is no post-test ID
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No post-test available for this topic.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('chapters')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> chaptersSnapshot) {
          if (!chaptersSnapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.teal[300]));
          }

          final totalChapters = chaptersSnapshot.data!.docs.length;

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('completed_chapters')
                .where('topicId', isEqualTo: widget.topicId)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> completedSnapshot) {
              if (!completedSnapshot.hasData) {
                return Center(child: CircularProgressIndicator(color: Colors.teal[300]));
              }

              final completedChapterIds = completedSnapshot.data!.docs
                  .map((doc) => doc['chapterId'])
                  .toSet();

              final completedChapters = completedChapterIds.length;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LinearProgressIndicator(
                      value: totalChapters > 0 ? completedChapters / totalChapters : 0,
                      backgroundColor: Colors.grey[300],
                      color: Colors.teal[300],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '$completedChapters of $totalChapters chapters completed',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      itemCount: chaptersSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var chapter = chaptersSnapshot.data!.docs[index];
                        bool isCompleted = completedChapterIds.contains(chapter.id);

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: isCompleted
                                ? Icon(Icons.check_circle, color: Colors.teal[300])
                                : Icon(Icons.circle_outlined, color: Colors.grey[600]),
                            title: Text(
                              chapter['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[700], // Color to match theme
                              ),
                            ),
                            subtitle: Text(
                              chapter['description'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterDetailPage(
                                    topicId: widget.topicId,
                                    chapterId: chapter.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
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

  void _showPostTestWarning(BuildContext context, String testId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post-Test Required'),
          content: Text('You need to complete the post-test to finish the topic.'),
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
