import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChapterDetailPage extends StatefulWidget {
  final String chapterId;
  final String topicId;

  ChapterDetailPage({required this.chapterId, required this.topicId});

  @override
  _ChapterDetailPageState createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  late Future<DocumentSnapshot> _chapterFuture;
  late Future<List<DocumentSnapshot>> _chaptersFuture;

  @override
  void initState() {
    super.initState();
    _chapterFuture = FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection('chapters')
        .doc(widget.chapterId)
        .get();
    _chaptersFuture = FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection('chapters')
        .orderBy('order') // Assuming there is an 'order' field to sort chapters
        .get()
        .then((snapshot) => snapshot.docs);
  }

  void _navigateToChapter(String chapterId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterDetailPage(
          chapterId: chapterId,
          topicId: widget.topicId,
        ),
      ),
    );
  }

  Future<void> _markChapterAsRead(String chapterId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('completed_chapters')
        .add({
      'chapterId': chapterId,
      'topicId': widget.topicId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chapter marked as completed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: _chapterFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (snapshot.hasData) {
              var chapter = snapshot.data!;
              return Text(chapter['title'] ?? 'Chapter Details');
            } else {
              return Text('No Title');
            }
          },
        ),
        backgroundColor: Colors.grey[900], // Dark background
        iconTheme: IconThemeData(color: Colors.white), // White icons
        actions: [
          FutureBuilder<DocumentSnapshot>(
            future: _chapterFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink(); // Placeholder if data is not yet loaded
              }

              return IconButton(
                icon: Icon(Icons.check, color: Colors.white),
                onPressed: () => _markChapterAsRead(widget.chapterId),
                tooltip: 'Mark as Completed',
              );
            },
          ),
          // Previous Chapter Button
          FutureBuilder<List<DocumentSnapshot>>(
            future: _chaptersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink(); // Placeholder
              } else if (snapshot.hasError || !snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.navigate_before, color: Colors.white),
                  onPressed: null, // No chapters or error
                  tooltip: 'Previous Chapter',
                );
              } else {
                var chapters = snapshot.data!;
                var currentIndex = chapters.indexWhere((doc) => doc.id == widget.chapterId);
                return IconButton(
                  icon: Icon(Icons.navigate_before, color: Colors.white),
                  onPressed: currentIndex > 0
                      ? () => _navigateToChapter(chapters[currentIndex - 1].id)
                      : null, // Disable if it's the first chapter
                  tooltip: 'Previous Chapter',
                );
              }
            },
          ),
          // Next Chapter Button
          FutureBuilder<List<DocumentSnapshot>>(
            future: _chaptersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink(); // Placeholder
              } else if (snapshot.hasError || !snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.navigate_next, color: Colors.white),
                  onPressed: null, // No chapters or error
                  tooltip: 'Next Chapter',
                );
              } else {
                var chapters = snapshot.data!;
                var currentIndex = chapters.indexWhere((doc) => doc.id == widget.chapterId);
                return IconButton(
                  icon: Icon(Icons.navigate_next, color: Colors.white),
                  onPressed: currentIndex < chapters.length - 1
                      ? () => _navigateToChapter(chapters[currentIndex + 1].id)
                      : null, // Disable if it's the last chapter
                  tooltip: 'Next Chapter',
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _chapterFuture,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.purple[300]));
          }

          var chapter = snapshot.data!;
          return Column(
            children: [
              // Image Section
              Expanded(
                flex: 3,
                child: Center(
                  child: chapter['modelUrl'] != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      chapter['modelUrl'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(color: Colors.purple[300]),
                          );
                        }
                      },
                    ),
                  )
                      : Text('No image or model available', style: TextStyle(color: Colors.grey[500])),
                ),
              ),
              // Description Section
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter['title'] ?? 'Chapter Title',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Light text for dark mode
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        chapter['description'] ?? 'No description available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[300], // Light grey text for dark mode
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
