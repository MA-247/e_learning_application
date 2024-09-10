import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:e_learning_application/screens/faculty_side/testing_system/test_upload_confirmation_screen.dart';
import 'package:e_learning_application/widgets/loading_screen.dart';
import 'package:e_learning_application/widgets/dynamic_field_type.dart';

class CreateTestPage extends StatefulWidget {
  @override
  _CreateTestPageState createState() => _CreateTestPageState();
}

class _CreateTestPageState extends State<CreateTestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  List<DynamicField> _fields = [];

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

  Future<void> _uploadTest() async {
    if (_formKey.currentState!.validate()) {
      // Show the loading screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );

      try {
        // Upload images to Firebase Storage
        for (var field in _fields) {
          if (field.type == FieldType.image && field.image != null) {
            final storageRef = FirebaseStorage.instance.ref().child(
                'test_images/${DateTime.now().toString()}');
            await storageRef.putFile(field.image!);
            field.text = await storageRef.getDownloadURL();
          }
        }

        // Prepare field data for Firestore
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
                'score': field.score,
              };
            case FieldType.heading:
              return {'type': 'heading', 'content': field.headingText};
            default:
              return <String, dynamic>{};
          }
        }).toList();

        // Add test data to Firestore
        await FirebaseFirestore.instance.collection('tests').add({
          'title': _titleController.text,
          'fields': fieldData,
        });

        // Pop the loading screen and navigate to the confirmation screen
        Navigator.pop(context); // Close the loading screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TestUploadConfirmationScreen()),
        );
      } catch (e) {
        // Pop the loading screen and show an error message
        Navigator.pop(context); // Close the loading screen

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload test: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Test', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.teal,
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
                decoration: _inputDecoration('Test Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a test title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _fields.length,
                  itemBuilder: (context, index) {
                    final field = _fields[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: ListTile(
                        title: field.type == FieldType.heading
                            ? TextFormField(
                          decoration: _inputDecoration('Heading'),
                          validator: (value) => value!.isEmpty
                              ? 'Enter heading text'
                              : null,
                          initialValue: field.headingText,
                          onChanged: (value) => field.headingText = value,
                        )
                            : field.type == FieldType.text
                            ? TextFormField(
                          decoration: _inputDecoration('Text'),
                          validator: (value) => value!.isEmpty
                              ? 'Enter text'
                              : null,
                          initialValue: field.text,
                          onChanged: (value) => field.text = value,
                        )
                            : field.type == FieldType.image
                            ? Column(
                          children: [
                            field.image != null
                                ? ClipRRect(
                              borderRadius:
                              BorderRadius.circular(8),
                              child: Image.file(
                                field.image!,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                                : ElevatedButton.icon(
                              onPressed: () =>
                                  _pickImage(field),
                              icon: Icon(Icons.upload_file),
                              label: Text('Upload Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                textStyle: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                            : field.type == FieldType.mcq
                            ? Column(
                          children: [
                            TextFormField(
                              decoration: _inputDecoration('Question'),
                              validator: (value) => value!.isEmpty
                                  ? 'Enter a question'
                                  : null,
                              initialValue: field.question,
                              onChanged: (value) =>
                              field.question = value,
                            ),
                            _buildOptionField(field, 'Option 1', 1),
                            _buildOptionField(field, 'Option 2', 2),
                            _buildOptionField(field, 'Option 3', 3),
                            _buildOptionField(field, 'Option 4', 4),
                            TextFormField(
                              decoration: _inputDecoration('Score'),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                              value!.isEmpty ? 'Enter the score' : null,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showAddFieldDialog,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18),
                    SizedBox(width: 8),
                    Text('Add Field'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadTest,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload, size: 18),
                    SizedBox(width: 8),
                    Text('Submit Test'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.tealAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildOptionField(DynamicField field, String label, int optionNumber) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: _inputDecoration(label),
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
              field.correctOption = _getOptionText(field, optionNumber);
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
  }
}
