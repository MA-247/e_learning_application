import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum FieldType { text, heading, image, mcq, emq }

class DynamicField {
  FieldType type;
  String text = '';
  String headingText = '';
  File? image;
  String question = '';
  String option1 = '', option2 = '', option3 = '', option4 = '';
  int correctOption = 1;
  int? score;
  List<File?> emqImages = [];  // For storing the images of EMQ
  List<String> emqLabels = []; // To store the labels for each image

  DynamicField({required this.type});
}

class AddChapterPage extends StatefulWidget {
  @override
  final String topicId; // Accept topicId as an argument

  const AddChapterPage({required this.topicId, Key? key}) : super(key: key);

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

  Future<void> _pickEmqImage(DynamicField field, int index) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (field.emqImages.length <= index) {
          field.emqImages.add(File(pickedFile.path));
        } else {
          field.emqImages[index] = File(pickedFile.path);
        }
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
              ListTile(
                title: Text('EMQ'),
                onTap: () {
                  Navigator.of(context).pop();
                  _addField(FieldType.emq);
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
      final newField = DynamicField(type: type);
      if (type == FieldType.emq) {
        // Initialize the EMQ field with 1 empty image and label
        newField.emqImages.add(null);
        newField.emqLabels.add('');
      }
      _fields.add(newField);
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

          // For EMQ type, upload the 4 images
          if (field.type == FieldType.emq) {
            for (int i = 0; i < field.emqImages.length; i++) {
              if (field.emqImages[i] != null) {
                final storageRef = FirebaseStorage.instance
                    .ref()
                    .child('emq_images/${DateTime.now().toString()}');
                await storageRef.putFile(field.emqImages[i]!);
                String imageUrl = await storageRef.getDownloadURL();
                field.emqImages[i] = File(imageUrl); // Store the image URL
              }
            }
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
            case FieldType.emq:
              return {
                'type': 'emq',
                'question': field.question,
                'images': field.emqImages.map((e) => e?.path).toList(), // Store image paths or URLs
                'labels': field.emqLabels, // Add labels for EMQ images
              };
            default:
              return {}; // This still returns an empty map
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
              initialValue: field.question,
              onChanged: (value) => field.question = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 1'),
              initialValue: field.option1,
              onChanged: (value) => field.option1 = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 2'),
              initialValue: field.option2,
              onChanged: (value) => field.option2 = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 3'),
              initialValue: field.option3,
              onChanged: (value) => field.option3 = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Option 4'),
              initialValue: field.option4,
              onChanged: (value) => field.option4 = value,
            ),
          ],
        );
      case FieldType.emq:
        return Column(
          children: [
            for (int i = 0; i < field.emqImages.length; i++) ...[
              ElevatedButton.icon(
                onPressed: () => _pickEmqImage(field, i),
                icon: Icon(Icons.image),
                label: Text('Pick Image ${i + 1}'),
              ),
              field.emqImages[i] != null
                  ? Image.file(field.emqImages[i]!, height: 100)
                  : SizedBox(),
              TextFormField(
                decoration: InputDecoration(labelText: 'Label for Image ${i + 1}'),
                initialValue: field.emqLabels.length > i
                    ? field.emqLabels[i]
                    : '',
                onChanged: (value) {
                  if (field.emqLabels.length <= i) {
                    field.emqLabels.add(value);
                  } else {
                    field.emqLabels[i] = value;
                  }
                },
              ),
            ],
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }
}
