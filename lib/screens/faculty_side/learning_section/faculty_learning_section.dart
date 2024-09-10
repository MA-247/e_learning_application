import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_chapters_page.dart';

class ManageTopicsPage extends StatelessWidget {
  final User user;

  ManageTopicsPage({required this.user});

  Future<void> _addOrEditTopic(BuildContext context, {String? topicId, String? initialTitle, String? initialPretestId, String? initialPosttestId}) async {
    final topicTitleController = TextEditingController(text: initialTitle);
    String? selectedPretestId = initialPretestId;
    String? selectedPosttestId = initialPosttestId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(topicId == null ? 'Add New Topic' : 'Edit Topic'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: topicTitleController,
                decoration: InputDecoration(hintText: 'Topic Title'),
              ),
              SizedBox(height: 10),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('tests').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var tests = snapshot.data!.docs;
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedPretestId,
                        decoration: InputDecoration(labelText: 'Select Pretest'),
                        items: tests.map((test) {
                          return DropdownMenuItem<String>(
                            value: test.id,
                            child: Text(test['title']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedPretestId = value;
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedPosttestId,
                        decoration: InputDecoration(labelText: 'Select Post-test'),
                        items: tests.map((test) {
                          return DropdownMenuItem<String>(
                            value: test.id,
                            child: Text(test['title']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedPosttestId = value;
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final title = topicTitleController.text;
                if (title.isNotEmpty) {
                  if (topicId == null) {
                    await FirebaseFirestore.instance.collection('topics').add({
                      'title': title,
                      'pretestId': selectedPretestId,
                      'posttestId': selectedPosttestId,
                    });
                  } else {
                    await FirebaseFirestore.instance.collection('topics').doc(topicId).update({
                      'title': title,
                      'pretestId': selectedPretestId,
                      'posttestId': selectedPosttestId,
                    });
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Title cannot be empty')));
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
      await FirebaseFirestore.instance.collection('topics').doc(topicId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Topic deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Topics'),
        backgroundColor: Colors.teal[300], // Updated color
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
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    topic['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Pretest: ${topic['pretestId'] ?? 'None'}, Post-test: ${topic['posttestId'] ?? 'None'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _addOrEditTopic(
                          context,
                          topicId: topic.id,
                          initialTitle: topic['title'],
                          initialPretestId: topic['pretestId'],
                          initialPosttestId: topic['posttestId'],
                        ),
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTopic(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[300], // Matching theme color
        tooltip: 'Add New Topic', // Added tooltip
      ),
    );
  }
}
