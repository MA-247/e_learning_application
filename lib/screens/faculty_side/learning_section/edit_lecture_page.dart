import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditLecturePage extends StatefulWidget {
  final String topicId;
  final String chapterId;
  final String initialTitle;
  final String? initialDescription;
  final String? initialImageUrl;

  EditLecturePage({
    required this.topicId,
    required this.chapterId,
    required this.initialTitle,
    this.initialDescription,
    this.initialImageUrl,
  });

  @override
  _EditLecturePageState createState() => _EditLecturePageState();
}

class _EditLecturePageState extends State<EditLecturePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  File? _imageFile;
  bool _isImageUpdated = false;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _description = widget.initialDescription ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
      _isImageUpdated = true;
    });
  }

  Future<String?> _uploadImageToFirebase(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('chapter_images/${DateTime.now().toString()}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _editChapter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? imageUrl = widget.initialImageUrl;

      if (_isImageUpdated && _imageFile != null) {
        imageUrl = await _uploadImageToFirebase(_imageFile!);
      }

      await FirebaseFirestore.instance
          .collection('topics')
          .doc(widget.topicId)
          .collection('chapters')
          .doc(widget.chapterId)
          .update({
        'title': _title,
        'description': _description,
        'modelUrl': imageUrl,
      });

      Navigator.of(context).pop(); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Lecture'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              Text('Current Image:'),
              if (widget.initialImageUrl != null)
                Image.network(widget.initialImageUrl!),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Update Image'),
              ),
              if (_imageFile != null)
                Image.file(_imageFile!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editChapter,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
