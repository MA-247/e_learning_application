import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum FieldType { text, image, mcq }

class DynamicField {
  FieldType type;
  String? text;
  File? image;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? correctOption;

  DynamicField({required this.type});
}

class CreateTestPage extends StatefulWidget {
  @override
  _CreateTestPageState createState() => _CreateTestPageState();
}

class _CreateTestPageState extends State<CreateTestPage> {
  final _formKey = GlobalKey<FormState>();
  List<DynamicField> _fields = [];

  Future<void> _pickImage(DynamicField field) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        field.image = File(pickedFile.path);
      });
    }
  }

  void _addField(FieldType type) {
    setState(() {
      _fields.add(DynamicField(type: type));
    });
  }

  Future<void> _uploadTest() async {
    if (_formKey.currentState!.validate()) {
      for (var field in _fields) {
        if (field.type == FieldType.image && field.image != null) {
          final storageRef = FirebaseStorage.instance.ref().child('test_images/${DateTime.now().toString()}');
          await storageRef.putFile(field.image!);
          field.text = await storageRef.getDownloadURL();
        }
      }

      // Create a list of field data to store in Firestore
      List<Map<String, dynamic>> fieldData = _fields.map((field) {
        switch (field.type) {
          case FieldType.text:
            return {'type': 'text', 'content': field.text};
          case FieldType.image:
            return {'type': 'image', 'url': field.text};
          case FieldType.mcq:
            return {
              'type': 'mcq',
              'question': field.question,
              'options': [field.option1, field.option2, field.option3, field.option4],
              'correctOption': field.correctOption,
            };
          default:
            return <String, dynamic>{};
        }
      }).toList();

      await FirebaseFirestore.instance.collection('tests').add({
        'fields': fieldData,
      });

      // Show a success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Test uploaded successfully!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Test'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _fields.length,
                  itemBuilder: (context, index) {
                    final field = _fields[index];
                    switch (field.type) {
                      case FieldType.text:
                        return TextFormField(
                          decoration: InputDecoration(labelText: 'Text'),
                          validator: (value) => value!.isEmpty ? 'Enter text' : null,
                          onChanged: (value) => field.text = value,
                        );
                      case FieldType.image:
                        return Column(
                          children: [
                            field.image != null
                                ? Image.file(field.image!)
                                : ElevatedButton(
                              onPressed: () => _pickImage(field),
                              child: Text('Upload Image'),
                            ),
                          ],
                        );
                      case FieldType.mcq:
                        return Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Question'),
                              validator: (value) => value!.isEmpty ? 'Enter a question' : null,
                              onChanged: (value) => field.question = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 1'),
                              validator: (value) => value!.isEmpty ? 'Enter option 1' : null,
                              onChanged: (value) => field.option1 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 2'),
                              validator: (value) => value!.isEmpty ? 'Enter option 2' : null,
                              onChanged: (value) => field.option2 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 3'),
                              validator: (value) => value!.isEmpty ? 'Enter option 3' : null,
                              onChanged: (value) => field.option3 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 4'),
                              validator: (value) => value!.isEmpty ? 'Enter option 4' : null,
                              onChanged: (value) => field.option4 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Correct Option'),
                              validator: (value) => value!.isEmpty ? 'Enter the correct option' : null,
                              onChanged: (value) => field.correctOption = value,
                            ),
                          ],
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _addField(FieldType.text),
                    child: Text('Add Text'),
                  ),
                  ElevatedButton(
                    onPressed: () => _addField(FieldType.image),
                    child: Text('Add Image'),
                  ),
                  ElevatedButton(
                    onPressed: () => _addField(FieldType.mcq),
                    child: Text('Add MCQ'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadTest,
                child: Text('Submit Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
