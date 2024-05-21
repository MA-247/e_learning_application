import 'package:flutter/material.dart';
import 'package:e_learning_application/models/topic.dart';
import 'package:flutter_cube/flutter_cube.dart';

class TopicDetail extends StatelessWidget {
  final Topic topic;

  TopicDetail({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title + ": " + topic.subtitle,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),),),
        body: Column(
          children: <Widget>[
            Expanded(flex: 3,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  children: <Widget>[
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
                    Container(
                      width: constraints.maxWidth - 96,
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
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward)),
                  ],
                );
              }
            ),
            ),

            Padding(padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.red,
              ),),
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