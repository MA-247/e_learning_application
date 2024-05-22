import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/models/topic.dart';
import 'package:e_learning_application/screens/topic_detail.dart';
import 'package:e_learning_application/widgets/custom_listTile.dart';
import 'package:e_learning_application/models/chapters.dart';

class LearningSection extends StatelessWidget {
  final User user;

  LearningSection({required this.user});

  @override
  Widget build(BuildContext context) {
    // Fetch and display the list of topics
    // For simplicity, using static data
    List<Chapter> chapters = [
      Chapter(id: '1', title: 'Healthy Tooth', description: 'First Chapter', modelUrl: 'assets/pHTooth.obj'),
      Chapter(id: '2', title: 'Decaying Tooth', description: 'Second Chapter', modelUrl: 'assets/pHTooth.obj'),
    ];
    List<Topic> topics = [
      Topic(id: '1', title: 'Topic 1: Testing', chapters: chapters),
      Topic(id: '2', title: 'Topic 2', chapters: chapters),
      // Other topics
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Learning Section',
      style: TextStyle(
        color: Colors.white,

      ),),
      backgroundColor: Colors.blue[300],),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return CustomListTile(
            title: topic.title,
            subtitle: "Just Checking",
            topic: topic,
          );
        },
      ),
    );
  }
}
