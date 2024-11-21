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
    final userId = FirebaseAuth.instance.currentUser!.uid;
    var colorScheme = Theme.of(context).colorScheme;
    var textColor = colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapters'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
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
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async => _handlePostTest(userId),
            child: const Text(
              'Take Test',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('chapters')
            .snapshots(),
        builder: (context, chaptersSnapshot) {
          if (chaptersSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chaptersSnapshot.hasData || chaptersSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chapters available.'));
          }

          final chapters = chaptersSnapshot.data!.docs;
          final totalChapters = chapters.length;

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('completed_chapters')
                .where('topicId', isEqualTo: widget.topicId)
                .get(),
            builder: (context, completedSnapshot) {
              if (completedSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final completedChapterIds = completedSnapshot.data!.docs
                  .map((doc) => doc['chapterId'])
                  .toSet();
              final completedChapters = completedChapterIds.length;

              // Filter chapters based on search query
              final filteredChapters = chapters.where((chapter) {
                final title = chapter['title'].toString().toLowerCase();
                return title.contains(searchQuery);
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LinearProgressIndicator(
                      value: totalChapters > 0
                          ? completedChapters / totalChapters
                          : 0,
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
                    child: filteredChapters.isEmpty
                        ? const Center(child: Text('No chapters found.'))
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: filteredChapters.length,
                      itemBuilder: (context, index) {
                        final chapter = filteredChapters[index];
                        final isCompleted =
                        completedChapterIds.contains(chapter.id);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: isCompleted
                                  ? Colors.teal[300]
                                  : Colors.grey[600],
                            ),
                            title: Text(
                              chapter['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[700],
                              ),
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

  Future<void> _handlePostTest(String userId) async {
    final topicDoc = await FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .get();
    final postTestId = topicDoc['posttestId'];

    if (postTestId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No post-test available for this topic.')),
      );
      return;
    }

    final postTestCompleted = await _isTestCompleted(postTestId, userId);
    if (postTestCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already completed the post-test.')),
      );
    } else {
      _showPostTestWarning(context, postTestId, userId);
    }
  }

  Future<bool> _isTestCompleted(String testId, String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('student_responses')
        .where('testId', isEqualTo: testId)
        .where('userId', isEqualTo: userId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  void _showPostTestWarning(BuildContext context, String testId, String userId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Post-Test Required'),
        content: const Text('You need to complete the post-test to finish the topic.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Start Post-Test'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TestPage(testId: testId, userId: userId, isPreTest: false),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
