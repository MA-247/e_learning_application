import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ManageChaptersPage extends StatefulWidget {
  final String topicId;

  ManageChaptersPage({required this.topicId});

  @override
  _ManageChaptersPageState createState() => _ManageChaptersPageState();
}

class _ManageChaptersPageState extends State<ManageChaptersPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  File? _imageFile;
  bool _isUploading = false;

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

  Future<void> _addChapter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isUploading = true;
      });

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImageToFirebase(_imageFile!);
      }

      await FirebaseFirestore.instance.collection('topics').doc(widget.topicId).collection('chapters').add({
        'title': _title,
        'description': _description,
        'modelUrl': imageUrl,
      });

      setState(() {
        _isUploading = false;
      });

      Navigator.of(context).pop(); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Chapters'),
        backgroundColor: Colors.blue[300],
      ),
      body: _isUploading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Chapter Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a chapter title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _title = value ?? '';
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Chapter Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a chapter description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _description = value ?? '';
                          },
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            _imageFile == null
                                ? Text('No image selected.')
                                : Image.file(_imageFile!, width: 100, height: 100, fit: BoxFit.cover),
                            SizedBox(width: 16.0),
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: Icon(Icons.image),
                              label: Text('Pick Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[300],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Center(
                          child: ElevatedButton(
                            onPressed: _addChapter,
                            child: Text('Add Chapter'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300],
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
