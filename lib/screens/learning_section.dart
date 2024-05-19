import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/models/topic.dart';
import 'package:e_learning_application/screens/topic_detail.dart';

class LearningSection extends StatelessWidget {
  final User user;

  LearningSection({required this.user});

  @override
  Widget build(BuildContext context) {
    // Fetch and display the list of topics
    // For simplicity, using static data
    List<Topic> topics = [
      Topic(id: '1', title: 'Topic 1', description: 'Description 1', modelUrl: 'url1'),
      // Other topics
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Learning Section')),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return ListTile(
            title: Text(topic.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TopicDetail(topic: topic)),
              );
            },
          );
        },
      ),
    );
  }
}
