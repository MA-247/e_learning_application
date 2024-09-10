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
  bool _isLoading = false;

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

      setState(() {
        _isLoading = true;
      });

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
        await FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('chapters')
            .doc(chapterId)
            .update(chapterData);
      } else {
        await FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('chapters')
            .add(chapterData);
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
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
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(chapterId == null ? 'Add Chapter' : 'Edit Chapter'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: initialTitle,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => _title = value!,
                      validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: initialDescription,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => _description = value!,
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Choose Image'),
                    ),
                    if (_imageFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.file(
                          _imageFile!,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                if (chapterId != null)
                  TextButton(
                    onPressed: () {
                      _deleteChapter(chapterId);
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: _isLoading ? null : () => _addOrEditChapter(chapterId: chapterId),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(chapterId == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Chapters'),
        backgroundColor: Colors.teal[300],
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
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    chapter['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chapter['description'] ?? 'No description available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showChapterDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[300],
      ),
    );
  }
}
