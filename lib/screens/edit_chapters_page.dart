import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditChaptersPage extends StatefulWidget {
  final String topicId;

  EditChaptersPage({required this.topicId});

  @override
  _EditChaptersPageState createState() => _EditChaptersPageState();
}

class _EditChaptersPageState extends State<EditChaptersPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<String?> _uploadImageToFirebase(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('chapter_images/${DateTime.now().toString()}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _addOrEditChapter({String? chapterId}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImageToFirebase(_imageFile!);
      }

      final chapterData = {
        'title': _title,
        'description': _description,
        'modelUrl': imageUrl,
      };

      if (chapterId != null) {
        // Edit existing chapter
        await FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('chapters')
            .doc(chapterId)
            .update(chapterData);
      } else {
        // Add new chapter
        await FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('chapters')
            .add(chapterData);
      }

      Navigator.of(context).pop(); // Return to the previous screen
    }
  }

  Future<void> _deleteChapter(String chapterId) async {
    await FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection('chapters')
        .doc(chapterId)
        .delete();
  }

  void _showChapterDialog({String? chapterId, String? initialTitle, String? initialDescription}) {
    _title = initialTitle ?? '';
    _description = initialDescription ?? '';
    _imageFile = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(chapterId == null ? 'Add Chapter' : 'Edit Chapter'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: initialTitle,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) => _title = value!,
                  validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
                ),
                TextFormField(
                  initialValue: initialDescription,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value!,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Choose Image'),
                ),
              ],
            ),
          ),
          actions: [
            if (chapterId != null)
              TextButton(
                onPressed: () {
                  _deleteChapter(chapterId);
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _addOrEditChapter(chapterId: chapterId),
              child: Text(chapterId == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Chapters'),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showChapterDialog(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
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
                subtitle: Text(chapter['description'] ?? 'No description available'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteChapter(chapter.id);
                  },
                ),
                onTap: () => _showChapterDialog(
                  chapterId: chapter.id,
                  initialTitle: chapter['title'],
                  initialDescription: chapter['description'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
