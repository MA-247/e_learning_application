import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:e_learning_application/screens/test_upload_confirmation_screen.dart';
import 'package:e_learning_application/widgets/loading_screen.dart';
import 'package:e_learning_application/widgets/dynamic_field_type.dart';

class CreateTestPage extends StatefulWidget {
  @override
  _CreateTestPageState createState() => _CreateTestPageState();
}

class _CreateTestPageState extends State<CreateTestPage> {
  final _formKey = GlobalKey<FormState>();
  List<DynamicField> _fields = [];

  Future<void> _pickImage(DynamicField field) async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

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

  Future<void> _uploadTest() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );

      try {
        for (var field in _fields) {
          if (field.type == FieldType.image && field.image != null) {
            final storageRef = FirebaseStorage.instance.ref().child(
                'test_images/${DateTime.now().toString()}');
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
                'options': [
                  field.option1,
                  field.option2,
                  field.option3,
                  field.option4
                ],
                'correctOption': field.correctOption,
                'score': field.score, // Add this line
              };
            case FieldType.heading:
              return {'type': 'heading', 'content': field.headingText};
            default:
              return <String, dynamic>{};
          }
        }).toList();

        await FirebaseFirestore.instance.collection('tests').add({
          'fields': fieldData,
        });

        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TestUploadConfirmationScreen()),
        );
      } catch (e) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload test: $e')));
      }
    }
  }

  @override
  // In CreateTestPage class

  @override
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
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: field.type == FieldType.heading
                            ? TextFormField(
                          decoration: InputDecoration(labelText: 'Heading'),
                          validator: (value) =>
                          value!.isEmpty
                              ? 'Enter heading text'
                              : null,
                          initialValue: field.headingText,
                          onChanged: (value) => field.headingText = value,
                        )
                            : field.type == FieldType.text
                            ? TextFormField(
                          decoration: InputDecoration(labelText: 'Text'),
                          validator: (value) =>
                          value!.isEmpty
                              ? 'Enter text'
                              : null,
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
                              decoration: InputDecoration(
                                  labelText: 'Question'),
                              validator: (value) =>
                              value!.isEmpty
                                  ? 'Enter a question'
                                  : null,
                              initialValue: field.question,
                              onChanged: (value) => field.question = value,
                            ),
                            _buildOptionField(field, 'Option 1', 1),
                            _buildOptionField(field, 'Option 2', 2),
                            _buildOptionField(field, 'Option 3', 3),
                            _buildOptionField(field, 'Option 4', 4),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Score'),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                              value!.isEmpty
                                  ? 'Enter the score'
                                  : null,
                              initialValue: field.score?.toString(),
                              onChanged: (value) =>
                              field.score = int.tryParse(value),
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
                child: Text('Submit Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(DynamicField field, String label, int optionNumber) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: label),
            validator: (value) => value!.isEmpty ? 'Enter $label' : null,
            initialValue: _getOptionText(field, optionNumber),
            onChanged: (value) => _setOptionText(field, optionNumber, value),
          ),
        ),
        Radio<int>(
          value: optionNumber,
          groupValue: field.correctOptionNumber,
          onChanged: (int? value) {
            setState(() {
              field.correctOptionNumber = value!;
              field.correctOption =
                  _getOptionText(field, optionNumber); // Update correctOption
            });
          },
        ),
      ],
    );
  }

  String? _getOptionText(DynamicField field, int optionNumber) {
    switch (optionNumber) {
      case 1:
        return field.option1;
      case 2:
        return field.option2;
      case 3:
        return field.option3;
      case 4:
        return field.option4;
      default:
        return '';
    }
  }

  void _setOptionText(DynamicField field, int optionNumber, String value) {
    setState(() {
      switch (optionNumber) {
        case 1:
          field.option1 = value;
          break;
        case 2:
          field.option2 = value;
          break;
        case 3:
          field.option3 = value;
          break;
        case 4:
          field.option4 = value;
          break;
      }
    });
  }
}
