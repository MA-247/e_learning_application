import 'package:flutter/material.dart';
import 'package:e_learning_application/models/topic.dart';
import 'package:flutter_cube/flutter_cube.dart';

class TopicDetail extends StatefulWidget {
  final Topic topic;

  TopicDetail({required this.topic});

  @override
  State<TopicDetail> createState() => _TopicDetailState();
}

class _TopicDetailState extends State<TopicDetail> {
  int currentChapterIndex = 0;

  void goToNextChapter(){
    setState(() {
      if(currentChapterIndex < widget.topic.chapters.length - 1)
      {
        currentChapterIndex++;
      }
      else{
        currentChapterIndex = 0;
      }
    });
  }
  void goToPrevChapter(){
    setState(() {
      if(currentChapterIndex > 0)
      {
        currentChapterIndex--;
      }
      else if (currentChapterIndex == 0) {
        currentChapterIndex = widget.topic.chapters.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic.title,
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
                    IconButton(onPressed: (){
                      goToPrevChapter();
                    }, icon: Icon(Icons.arrow_back)),
                    Container(
                      width: constraints.maxWidth - 96,
                      child: Center(
                        child: Cube(
                          key: ValueKey(currentChapterIndex),
                        onSceneCreated: (Scene scene) {

                              scene.world.add(Object(
                        fileName: widget.topic.chapters[currentChapterIndex].modelUrl,
                              ));
                              //initial zoom
                          scene.camera.zoom = 20;

                        },
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){
                      goToNextChapter();
                    }, icon: Icon(Icons.arrow_forward)),
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
                      widget.topic.chapters[currentChapterIndex].description,
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