import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_chapters_page.dart';

class TopicsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
        backgroundColor: Colors.purple[300],
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('topics').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> topicsSnapshot) {
          if (!topicsSnapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.purple[300]));
          }

          var topics = topicsSnapshot.data!.docs;

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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentChaptersPage(topicId: topic.id),
                            ),
                          );
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentChaptersPage(topicId: topic.id),
                                ),
                              );
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentChaptersPage(topicId: topic.id),
                              ),
                            );
                          },
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
