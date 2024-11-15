import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_chapters_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart';

class TopicsListPage extends StatefulWidget {
  @override
  _TopicsListPageState createState() => _TopicsListPageState();
}

class _TopicsListPageState extends State<TopicsListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Topics', style: textTheme.displayLarge),
        backgroundColor: colorScheme.primary,
        elevation: 0,
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
                hintText: 'Search topics...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('topics').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> topicsSnapshot) {
          if (!topicsSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          var topics = topicsSnapshot.data!.docs.where((topic) {
            return (topic['title'] as String).toLowerCase().contains(searchQuery);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              var topic = topics[index];
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('topics')
                    .doc(topic.id)
                    .collection('chapters')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> chaptersSnapshot) {
                  if (!chaptersSnapshot.hasData) {
                    return _buildTopicCard(context, topic, 'Progress: Calculating...', null);
                  }

                  final totalChapters = chaptersSnapshot.data!.docs.length;
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('completed_chapters')
                        .where('topicId', isEqualTo: topic.id)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> completedSnapshot) {
                      if (!completedSnapshot.hasData) {
                        return _buildTopicCard(context, topic, 'Progress: Calculating...', null);
                      }

                      final completedChapterIds = completedSnapshot.data!.docs.map((doc) => doc['chapterId']).toSet();
                      final completedChapters = completedChapterIds.length;
                      final progress = totalChapters > 0 ? (completedChapters / totalChapters).toDouble() : 0.0;
                      final progressText = 'Progress: $completedChapters of $totalChapters chapters completed';

                      return _buildTopicCard(context, topic, progressText, progress);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, DocumentSnapshot topic, String progressText, double? progress) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          topic['title'],
          style: textTheme.displayLarge!.copyWith(color: colorScheme.primary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tap to view chapters', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.background,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: 4),
            Text(progressText, style: textTheme.labelMedium),
          ],
        ),
        onTap: () async {
          final topicData = await FirebaseFirestore.instance.collection('topics').doc(topic.id).get();
          final pretestId = topicData['pretestId'] as String?;

          if (pretestId != null) {
            final completedTestsSnapshot = await FirebaseFirestore.instance
                .collection('student_responses')
                .where('testId', isEqualTo: pretestId)
                .where('userId', isEqualTo: userId)
                .get();

            if (completedTestsSnapshot.docs.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pre-Test Required', style: textTheme.displayMedium),
                    content: Text('You must complete the pre-test before accessing this topic.', style: textTheme.bodyMedium),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestPage(testId: pretestId, isPreTest: true, userId: userId),
                            ),
                          );
                        },
                        child: Text('Take Pre-Test', style: textTheme.bodyMedium),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentChaptersPage(topicId: topic.id),
                ),
              );
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentChaptersPage(topicId: topic.id),
              ),
            );
          }
        },
      ),
    );
  }
}
