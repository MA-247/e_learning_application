import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentLearningSection extends StatelessWidget {
  final String topicId;

  StudentLearningSection({required this.topicId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
        backgroundColor: Colors.blue[300],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(topicId)
            .collection('chapters')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var chapters = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              var chapter = chapters[index];
              return ListTile(
                title: Text(chapter['title']),
                subtitle: Text(chapter['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChapterDetailPage(
                        chapterId: chapter.id,
                        topicId: topicId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChapterDetailPage extends StatefulWidget {
  final String chapterId;
  final String topicId;

  ChapterDetailPage({required this.chapterId, required this.topicId});

  @override
  _ChapterDetailPageState createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkIfCompleted();
  }

  Future<void> _checkIfCompleted() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final completedChapters = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('completed_chapters')
        .where('chapterId', isEqualTo: widget.chapterId)
        .get();

    setState(() {
      _isCompleted = completedChapters.docs.isNotEmpty;
    });
  }

  Future<void> _toggleCompletion() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (_isCompleted) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('completed_chapters')
          .where('chapterId', isEqualTo: widget.chapterId)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('completed_chapters')
          .add({
        'chapterId': widget.chapterId,
        'topicId': widget.topicId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      _isCompleted = !_isCompleted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isCompleted
            ? 'Chapter marked as completed'
            : 'Chapter marked as not completed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter Details'),
        backgroundColor: Colors.blue[300],
        actions: [
          Checkbox(
            value: _isCompleted,
            onChanged: (bool? value) {
              if (value != null) {
                _toggleCompletion();
              }
            },
            activeColor: Colors.green,
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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var chapter = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(chapter['description']),
                SizedBox(height: 20),
                if (chapter['modelUrl'] != null)
                  Image.network(chapter['modelUrl'])
                else
                  Text('No image or model available'),
              ],
            ),
          );
        },
      ),
    );
  }
}
