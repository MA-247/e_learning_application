import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_chapters_page.dart';

class ManageTopicsPage extends StatelessWidget {
  final User user;

  ManageTopicsPage({required this.user});

  Future<void> _addOrEditTopic(BuildContext context, {String? topicId, String? initialTitle}) async {
    final topicTitleController = TextEditingController(text: initialTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(topicId == null ? 'Add New Topic' : 'Edit Topic'),
          content: TextField(
            controller: topicTitleController,
            decoration: InputDecoration(hintText: 'Topic Title'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final title = topicTitleController.text;
                if (title.isNotEmpty) {
                  if (topicId == null) {
                    // Add new topic
                    await FirebaseFirestore.instance.collection('topics').add({'title': title});
                  } else {
                    // Edit existing topic
                    await FirebaseFirestore.instance.collection('topics').doc(topicId).update({'title': title});
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(topicId == null ? 'Add' : 'Save'),
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

  Future<void> _deleteTopic(BuildContext context, String topicId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Topic'),
          content: Text('Are you sure you want to delete this topic? This action cannot be undone.'),
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
      // Delete topic
      await FirebaseFirestore.instance.collection('topics').doc(topicId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Topic deleted')));
    }
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _addOrEditTopic(context, topicId: topic.id, initialTitle: topic['title']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTopic(context, topic.id),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditChaptersPage(topicId: topic.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTopic(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[300],
      ),
    );
  }
}
