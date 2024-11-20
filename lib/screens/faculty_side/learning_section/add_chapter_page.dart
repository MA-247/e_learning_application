import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum FieldType { text, heading, image, mcq }

class DynamicField {
  FieldType type;
  String text = '';
  String headingText = '';
  File? image;
  String question = '';
  String option1 = '', option2 = '', option3 = '', option4 = '';
  int correctOption = 1;
  int? score;

  DynamicField({required this.type});
}

class AddChapterPage extends StatefulWidget {
  @override
  _AddChapterPageState createState() => _AddChapterPageState();
}

class _AddChapterPageState extends State<AddChapterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  List<DynamicField> _fields = [];
  bool _isLoading = false;

  Future<void> _pickImage(DynamicField field) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        field.image = File(pickedFile.path);
      });
    }
  }

  void _showAddFieldDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Field Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Text'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addField(FieldType.text);
                },
              ),
              ListTile(
                title: Text('Heading'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addField(FieldType.heading);
                },
              ),
              ListTile(
                title: Text('Image'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addField(FieldType.image);
                },
              ),
              ListTile(
                title: Text('MCQ'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addField(FieldType.mcq);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addField(FieldType type) {
    setState(() {
      _fields.add(DynamicField(type: type));
    });
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  Future<void> _addChapter() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Upload images to Firebase Storage
        for (var field in _fields) {
          if (field.type == FieldType.image && field.image != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('chapter_images/${DateTime.now().toString()}');
            await storageRef.putFile(field.image!);
            field.text = await storageRef.getDownloadURL();
          }
        }

        // Prepare fields data for Firestore
        List<Map> fieldData = _fields.map((field) {
          switch (field.type) {
            case FieldType.text:
              return {'type': 'text', 'content': field.text};
            case FieldType.heading:
              return {'type': 'heading', 'content': field.headingText};
            case FieldType.image:
              return {'type': 'image', 'url': field.text};
            case FieldType.mcq:
              return {
                'type': 'mcq',
                'question': field.question,
                'options': [
                  field.option1,
                  field.option2,
                  field.option3,
                  field.option4
                ],
                'correctOption': field.correctOption,
                'score': field.score,
              };
            default:
              return {}; // This still returns an empty map, but it will be of type Map<String, dynamic>
          }
        }).toList();


        await FirebaseFirestore.instance.collection('chapters').add({
          'title': _titleController.text,
          'fields': fieldData,
          'createdAt': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chapter added successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add chapter: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Chapter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Chapter Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a chapter title' : null,
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _fields.length,
                  itemBuilder: (context, index) {
                    final field = _fields[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: _buildFieldWidget(field),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeField(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _showAddFieldDialog,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.add), SizedBox(width: 8), Text('Add Field')],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _addChapter,
                child: Text(_isLoading ? 'Saving...' : 'Save Chapter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWidget(DynamicField field) {
    switch (field.type) {
      case FieldType.text:
        return TextFormField(
          decoration: InputDecoration(labelText: 'Text Content'),
          initialValue: field.text,
          onChanged: (value) => field.text = value,
        );
      case FieldType.heading:
        return TextFormField(
          decoration: InputDecoration(labelText: 'Heading'),
          initialValue: field.headingText,
          onChanged: (value) => field.headingText = value,
        );
      case FieldType.image:
        return field.image != null
            ? Image.file(field.image!, height: 100)
            : ElevatedButton.icon(
          onPressed: () => _pickImage(field),
          icon: Icon(Icons.image),
          label: Text('Pick Image'),
        );
      case FieldType.mcq:
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Question'),
              onChanged: (value) => field.question = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 1'),
              onChanged: (value) => field.option1 = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 2'),
              onChanged: (value) => field.option2 = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 3'),
              onChanged: (value) => field.option3 = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 4'),
              onChanged: (value) => field.option4 = value,
            ),
          ],
        );
      default:
        return SizedBox();
    }
  }
}
