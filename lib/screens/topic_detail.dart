import 'package:flutter/material.dart';
import 'package:e_learning_application/models/topic.dart';
import 'package:flutter_cube/flutter_cube.dart';

class TopicDetail extends StatelessWidget {
  final Topic topic;

  TopicDetail({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
        body: Center(
        child: Container(
        height: 300,
        width: 300,
        child: Cube(
        onSceneCreated: (Scene scene) {
      scene.world.add(Object(
        fileName: 'assets/donut1.obj',
      ));
        },
        ),
        ),
        ),
    );
  }
}