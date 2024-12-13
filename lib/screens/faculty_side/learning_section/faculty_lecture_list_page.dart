import 'package:e_learning_application/screens/faculty_side/learning_section/add_chapter_page.dart';
import 'package:e_learning_application/screens/faculty_side/learning_section/edit_chapters_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChapterListPage extends StatelessWidget {
  final String topicId;

  ChapterListPage({required this.topicId});

  Future<void> _deleteChapter(BuildContext context, String chapterId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Chapter'),
          content: Text('Are you sure you want to delete this chapter? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      await FirebaseFirestore.instance.collection('topics').doc(topicId).collection("chapters").doc(chapterId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Chapter deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(topicId)
            .collection("chapters")
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
                  title: Text(chapter['title'], style: theme.textTheme.bodyLarge),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to chapter editing page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditChapterPage(
                                chapterId: chapter.id,
                                topicId: topicId,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: theme.primaryColor),
                        onPressed: () => _deleteChapter(context, chapter.id),
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
          // Navigate to add new chapter page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewChapterPage(topicId: topicId),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Chapter',
      ),
    );
  }
}
