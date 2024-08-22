import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_application/screens/manage_chapters_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageTopicsPage extends StatelessWidget {
  final User user;

  ManageTopicsPage({required this.user});

  Future<void> _addTopic(BuildContext context) async {
    final topicTitleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Topic'),
          content: TextField(
            controller: topicTitleController,
            decoration: InputDecoration(hintText: 'Topic Title'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final title = topicTitleController.text;
                if (title.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('topics').add({
                    'title': title,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Topics'),
        backgroundColor: Colors.blue[300],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('topics').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var topics = snapshot.data!.docs;

          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              var topic = topics[index];
              return ListTile(
                title: Text(topic['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageChaptersPage(topicId: topic.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTopic(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[300],
      ),
    );
  }
}
