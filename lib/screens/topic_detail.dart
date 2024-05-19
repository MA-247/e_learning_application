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
        body: Column(
          children: <Widget>[
            Expanded(flex: 2,
            child: Cube(
            onSceneCreated: (Scene scene) {
                  scene.world.add(Object(
            fileName: 'assets/pHTooth.obj',
                  ));
                  //initial zoom
              scene.camera.zoom = 50;


            },
            ),
            ),
            Expanded(
              flex : 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    "This is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the modelThis is the description of the model"
                              
                              
                  ),
                ),
              ),
            )
          ],
        ),

      );
  }
}