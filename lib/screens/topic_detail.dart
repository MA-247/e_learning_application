import 'package:flutter/material.dart';
import 'package:e_learning_application/models/topic.dart';

class TopicDetail extends StatelessWidget {
  final Topic topic;

  TopicDetail({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: Column(
        children: [
          // Use a 3D model viewer package to display the model
          // For simplicity, just displaying the URL
          Text('3D Model URL: ${topic.modelUrl}'),
          Text(topic.description),
        ],
      ),
    );
  }
}
