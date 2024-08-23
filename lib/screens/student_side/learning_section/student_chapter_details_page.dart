import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChapterDetailPage extends StatelessWidget {
  final String chapterId;
  final String topicId;

  ChapterDetailPage({required this.chapterId, required this.topicId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter Details'),
        backgroundColor: Colors.blue[300],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('topics')
            .doc(topicId)
            .collection('chapters')
            .doc(chapterId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var chapter = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(chapter['description']),
                SizedBox(height: 20),
                if (chapter['modelUrl'] != null)
                  Image.network(chapter['modelUrl'])
                else
                  Text('No image or model available'),
              ],
            ),
          );
        },
      ),
    );
  }
}
