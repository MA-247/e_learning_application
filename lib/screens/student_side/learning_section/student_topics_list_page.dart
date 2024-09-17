import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_chapters_page.dart';
import 'package:e_learning_application/screens/student_side/testing_system/take_test_page.dart'; // Make sure to create this page

class TopicsListPage extends StatefulWidget {
  @override
  _TopicsListPageState createState() => _TopicsListPageState();
}

class _TopicsListPageState extends State<TopicsListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
        backgroundColor: Colors.purple[300],
        elevation: 0,
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
                hintText: 'Search topics...',
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
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('topics').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> topicsSnapshot) {
          if (!topicsSnapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.purple[300]));
          }

          var topics = topicsSnapshot.data!.docs.where((topic) {
            return (topic['title'] as String).toLowerCase().contains(searchQuery);
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          topic['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tap to view chapters',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: null,
                              backgroundColor: Colors.grey[700],
                              color: Colors.purple[300],
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Progress: Calculating...',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        onTap: () async {
                          // Fetch the pretestId and posttestId for the topic
                          final topicData = await FirebaseFirestore.instance.collection('topics').doc(topic.id).get();
                          final pretestId = topicData['pretestId'] as String?;

                          // Check if the user has taken the pretest
                          if (pretestId != null) {
                            final completedTestsSnapshot = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .collection('completed_tests')
                                .where('testId', isEqualTo: pretestId)
                                .get();

                            if (completedTestsSnapshot.docs.isEmpty) {
                              // Show a message and redirect to the pre-test page
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Pre-Test Required'),
                                    content: Text('You must complete the pre-test before accessing this topic.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TestPage(testId: pretestId, isPreTest: true, userId: userId,),
                                            ),
                                          );
                                        },
                                        child: Text('Take Pre-Test'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // User has completed the pre-test, navigate to chapters
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentChaptersPage(topicId: topic.id),
                                ),
                              );
                            }
                          } else {
                            // No pre-test required, navigate to chapters
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
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              topic['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tap to view chapters',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: null,
                                  backgroundColor: Colors.grey[700],
                                  color: Colors.purple[300],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Progress: Calculating...',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            onTap: () async {
                              // Fetch the pretestId and posttestId for the topic
                              final topicData = await FirebaseFirestore.instance.collection('topics').doc(topic.id).get();
                              final pretestId = topicData['pretestId'] as String?;

                              // Check if the user has taken the pretest
                              if (pretestId != null) {
                                final completedTestsSnapshot = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('completed_tests')
                                    .where('testId', isEqualTo: pretestId)
                                    .get();

                                if (completedTestsSnapshot.docs.isEmpty) {
                                  // Show a message and redirect to the pre-test page
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Pre-Test Required'),
                                        content: Text('You must complete the pre-test before accessing this topic.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TestPage(testId: pretestId, isPreTest: true, userId: userId,),
                                                ),
                                              );
                                            },
                                            child: Text('Take Pre-Test'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // User has completed the pre-test, navigate to chapters
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentChaptersPage(topicId: topic.id),
                                    ),
                                  );
                                }
                              } else {
                                // No pre-test required, navigate to chapters
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

                      final completedChapterIds = completedSnapshot.data!.docs
                          .map((doc) => doc['chapterId'])
                          .toSet();

                      final completedChapters = completedChapterIds.length;
                      final progress = totalChapters > 0 ? (completedChapters / totalChapters).toDouble() : 0.0;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            topic['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tap to view chapters',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[700],
                                color: Colors.purple[300],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Progress: $completedChapters of $totalChapters chapters completed',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                            onTap: () async {
                              // Fetch the pretestId and posttestId for the topic
                              final topicData = await FirebaseFirestore.instance.collection('topics').doc(topic.id).get();
                              final pretestId = topicData['pretestId'] as String?;

                              if (pretestId != null) {
                                // Access the 'student_responses' collection for the current user
                                final completedTestsSnapshot = await FirebaseFirestore.instance
                                    .collection('student_responses')
                                    .where('testId', isEqualTo: pretestId)
                                    .where('userId', isEqualTo: userId)
                                    .get();

                                if (completedTestsSnapshot.docs.isEmpty) {
                                  // Show a message and redirect to the pre-test page
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Pre-Test Required'),
                                        content: Text('You must complete the pre-test before accessing this topic.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TestPage(testId: pretestId, userId: userId, isPreTest: true,),
                                                ),
                                              );
                                            },
                                            child: Text('Take Pre-Test'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // User has completed the pre-test, navigate to chapters
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentChaptersPage(topicId: topic.id),
                                    ),
                                  );
                                }
                              } else {
                                // No pre-test required, navigate to chapters
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentChaptersPage(topicId: topic.id),
                                  ),
                                );
                              }
                            }


                        ),
                      );
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
}
