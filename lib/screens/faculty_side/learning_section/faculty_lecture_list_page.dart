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
        backgroundColor: Colors.teal[300], // Updated theme color
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

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: chapter['modelUrl'] != null
                      ? Image.network(
                    chapter['modelUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.image, size: 50), // Placeholder icon
                  title: Text(
                    chapter['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chapter['description'] ?? 'No description available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
