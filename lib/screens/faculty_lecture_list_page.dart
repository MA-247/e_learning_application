import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_lecture_page.dart';

class LectureListPage extends StatelessWidget {
  final String topicId;

  LectureListPage({required this.topicId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
        backgroundColor: Colors.blue[300],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(topicId)
            .collection('chapters')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var chapters = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              var chapter = chapters[index];
              return ListTile(
                title: Text(chapter['title']),
                subtitle: Text(chapter['description'] ?? 'No description available'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditLecturePage(
                          topicId: topicId,
                          chapterId: chapter.id,
                          initialTitle: chapter['title'],
                          initialDescription: chapter['description'],
                          initialImageUrl: chapter['modelUrl'],
                        ),
                      ),
                    );
                  },
                ),
                onTap: () {
                  // Navigate to chapter details page (if needed)
                },
              );
            },
          );
        },
      ),
    );
  }
}
