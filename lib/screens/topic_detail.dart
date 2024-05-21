import 'package:flutter/material.dart';
import 'package:e_learning_application/models/topic.dart';
import 'package:flutter_cube/flutter_cube.dart';

class TopicDetail extends StatelessWidget {
  final Topic topic;

  TopicDetail({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title + ": " + topic.subtitle)),
        body: Column(
          children: <Widget>[
            Expanded(flex: 3,
            child: Center(
              child: Cube(
              onSceneCreated: (Scene scene) {
                    scene.world.add(Object(
              fileName: topic.modelUrl,
                    ));
                    //initial zoom
                scene.camera.zoom = 20;


              },
              ),
            ),
            ),
            Expanded(
              flex : 2,
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                      topic.description,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

      );
  }
}