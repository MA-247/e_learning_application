import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ChapterDetailPage extends StatefulWidget {
  final String topicId;
  final String chapterId;

  const ChapterDetailPage({
    Key? key,
    required this.topicId,
    required this.chapterId,
  }) : super(key: key);

  @override
  _ChapterDetailPageState createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  bool _isCompleted = false;
  bool _isLoading = true;
  late String userId;
  String? _imageUrl; // Variable to store the image URL
  String? _modelUrl; // Variable to store the model URL

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    _checkIfCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter Details',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          Tooltip(
            message: _isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
            child: Checkbox(
              value: _isCompleted,
              onChanged: (bool? value) {
                if (value != null) {
                  _toggleCompletion();
                }
              },
              activeColor: Colors.green,
              checkColor: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('chapters')
            .doc(widget.chapterId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.teal[300]),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Chapter not found'));
          }

          var chapter = snapshot.data!;
          _imageUrl = chapter['imageUrl'];  // Fetch the image URL
          _modelUrl = chapter['3dModelId'];  // Fetch the 3D model URL
          print(_modelUrl);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Chapter Title
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      chapter['title'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 2: 3D Model or Image Viewer
                  if (_modelUrl != null && _modelUrl!.isNotEmpty)

                    Container(
                      height: 400, // Adjusted height for better viewing
                      child: ModelViewer(
                        src: _modelUrl!, // Use the dynamic model URL from Firestore
                        alt: "3D Model not available",
                        autoRotate: false,
                        cameraControls: true,
                        interactionPrompt: InteractionPrompt.auto,
                        poster: _imageUrl ?? "assets/logos/PULPATH_logo.jpg", // Fallback to a default image if none exists
                        maxHotspotOpacity: 0.25,
                        minHotspotOpacity: 0.35,
                      ),
                    )
                  else if (_imageUrl != null && _imageUrl!.isNotEmpty)
                    Container(
                      height: 400, // Adjusted height for better viewing
                      child: Image.network(
                        _imageUrl!, // Use the dynamic image URL from Firestore
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Center(child: Text('No Model or Image Available')),

                  const SizedBox(height: 20),

                  // Section 3: Chapter Description
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      chapter['description'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Check if the chapter is already marked as completed by the user
  Future<void> _checkIfCompleted() async {
    try {
      final completedDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('completed_chapters')
          .doc(widget.chapterId)
          .get();

      if (completedDoc.exists) {
        setState(() {
          _isCompleted = true;
        });
      }
    } catch (e) {
      debugPrint('Error checking completion status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Toggle the completion status of the chapter
  Future<void> _toggleCompletion() async {
    final chapterRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('completed_chapters')
        .doc(widget.chapterId);

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isCompleted) {
        // If already completed, mark as incomplete (delete the document)
        await chapterRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chapter marked as incomplete')),
        );
      } else {
        // If not completed, mark as complete (add the document)
        await chapterRef.set({
          'topicId': widget.topicId,
          'chapterId': widget.chapterId,
          'completedAt': Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chapter marked as complete')),
        );
      }

      setState(() {
        _isCompleted = !_isCompleted;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
