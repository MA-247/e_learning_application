// import 'package:flutter/material.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_cube/flutter_cube.dart';
//
// class ChapterDetailPage extends StatefulWidget {
//   final String chapterId;
//   final String topicId;
//
//   ChapterDetailPage({required this.chapterId, required this.topicId});
//
//   @override
//   _ChapterDetailPageState createState() => _ChapterDetailPageState();
// }
//
// class _ChapterDetailPageState extends State<ChapterDetailPage> {
//   late Future<DocumentSnapshot> _chapterFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _chapterFuture = FirebaseFirestore.instance
//         .collection('topics')
//         .doc(widget.topicId)
//         .collection('chapters')
//         .doc(widget.chapterId)
//         .get();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chapter Details'),
//         backgroundColor: Colors.grey[900],
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: _chapterFuture,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator(color: Colors.purple[300]));
//           }
//
//           var chapter = snapshot.data!;
//           String? modelUrl = chapter['fileUrl']; // Ensure this is the correct path to your model URL
//
//           return Column(
//             children: [
//               // 3D Model Section
//               Expanded(
//                 flex: 3,
//                 child: Cube(
//                   onSceneCreated: (Scene scene){
//                     scene.world.add(Object(fileName: "assets/healthyTooth.obj"));
//                     scene.camera.zoom = 10;
//                   },
//                 )
//               ),
//               // Description Section
//               Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         chapter['title'] ?? 'Chapter Title',
//                         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         chapter['description'] ?? 'No description available',
//                         style: TextStyle(fontSize: 16, color: Colors.grey[300]),
//                       ),
//                       SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
