import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:e_learning_application/widgets/loading_screen.dart';
import 'package:e_learning_application/widgets/dynamic_field_type.dart';
import 'package:e_learning_application/screens/test_list_faculty_page.dart';

class EditTestPage extends StatefulWidget {
  final String testId;

  EditTestPage({required this.testId});

  @override
  _EditTestPageState createState() => _EditTestPageState();
}

class _EditTestPageState extends State<EditTestPage> {
  final _formKey = GlobalKey<FormState>();
  List<DynamicField> _fields = [];

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    try {
      DocumentSnapshot testSnapshot = await FirebaseFirestore.instance.collection('tests').doc(widget.testId).get();
      if (testSnapshot.exists) {
        var testData = testSnapshot.data() as Map<String, dynamic>;
        var fieldsData = testData['fields'] as List<dynamic>;

        setState(() {
          _fields = fieldsData.map<DynamicField>((fieldData) {
            switch (fieldData['type']) {
              case 'text':
                return DynamicField(type: FieldType.text)..text = fieldData['content'];
              case 'image':
                return DynamicField(type: FieldType.image)..text = fieldData['url'];
              case 'mcq':
                return DynamicField(type: FieldType.mcq)
                  ..question = fieldData['question']
                  ..option1 = fieldData['options'][0]
                  ..option2 = fieldData['options'][1]
                  ..option3 = fieldData['options'][2]
                  ..option4 = fieldData['options'][3]
                  ..correctOption = fieldData['correctOption'];
              case 'heading':
                return DynamicField(type: FieldType.heading)..headingText = fieldData['content'];
              default:
                return DynamicField(type: FieldType.text);
            }
          }).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load test data: $e')));
    }
  }

  Future<void> _uploadTest() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );

      try {
        for (var field in _fields) {
          if (field.type == FieldType.image && field.image != null) {
            final storageRef = FirebaseStorage.instance.ref().child('test_images/${DateTime.now().toString()}');
            await storageRef.putFile(field.image!);
            field.text = await storageRef.getDownloadURL();
          }
        }

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
            case FieldType.heading:
              return {'type': 'heading', 'content': field.headingText};
            default:
              return <String, dynamic>{};
          }
        }).toList();

        await FirebaseFirestore.instance.collection('tests').doc(widget.testId).update({
          'fields': fieldData,
        });

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TestListPage()),
        );
      } catch (e) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update test: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Test'),
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
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: field.type == FieldType.heading
                            ? Text(
                          field.headingText ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                            : field.type == FieldType.text
                            ? TextFormField(
                          decoration: InputDecoration(labelText: 'Text'),
                          validator: (value) => value!.isEmpty ? 'Enter text' : null,
                          initialValue: field.text,
                          onChanged: (value) => field.text = value,
                        )
                            : field.type == FieldType.image
                            ? Column(
                          children: [
                            field.image != null
                                ? Image.file(field.image!)
                                : ElevatedButton(
                              onPressed: () => _pickImage(field),
                              child: Text('Upload Image'),
                            ),
                          ],
                        )
                            : field.type == FieldType.mcq
                            ? Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Question'),
                              validator: (value) => value!.isEmpty ? 'Enter a question' : null,
                              initialValue: field.question,
                              onChanged: (value) => field.question = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 1'),
                              validator: (value) => value!.isEmpty ? 'Enter option 1' : null,
                              initialValue: field.option1,
                              onChanged: (value) => field.option1 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 2'),
                              validator: (value) => value!.isEmpty ? 'Enter option 2' : null,
                              initialValue: field.option2,
                              onChanged: (value) => field.option2 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 3'),
                              validator: (value) => value!.isEmpty ? 'Enter option 3' : null,
                              initialValue: field.option3,
                              onChanged: (value) => field.option3 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Option 4'),
                              validator: (value) => value!.isEmpty ? 'Enter option 4' : null,
                              initialValue: field.option4,
                              onChanged: (value) => field.option4 = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Correct Option'),
                              validator: (value) => value!.isEmpty ? 'Enter the correct option' : null,
                              initialValue: field.correctOption,
                              onChanged: (value) => field.correctOption = value,
                            ),
                          ],
                        )
                            : Container(),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeField(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _showAddFieldDialog,
                    child: Text('Add Field'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadTest,
                child: Text('Update Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(DynamicField field) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        field.image = File(pickedFile.path);
      });
    }
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
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
}
