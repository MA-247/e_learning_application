import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:e_learning_application/widgets/loading_screen.dart';
import 'package:e_learning_application/widgets/dynamic_field_type.dart';
import 'package:e_learning_application/screens/faculty_side/testing_system/test_list_faculty_page.dart';

class EditTestPage extends StatefulWidget {
  final String testId;

  EditTestPage({required this.testId});

  @override
  _EditTestPageState createState() => _EditTestPageState();
}

class _EditTestPageState extends State<EditTestPage> {
  final _formKey = GlobalKey<FormState>();
  List<DynamicField> _fields = [];
  String _testTitle = ''; // Add a variable to hold the test title

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
          _testTitle = testData['title'] ?? ''; // Load the test title
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
                  ..correctOption = fieldData['correctOption']
                  ..score = fieldData['score']; // Load the score
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
                'score': field.score, // Include score
              };
            case FieldType.heading:
              return {'type': 'heading', 'content': field.headingText};
            default:
              return <String, dynamic>{};
          }
        }).toList();

        await FirebaseFirestore.instance.collection('tests').doc(widget.testId).update({
          'title': _testTitle, // Update the test title
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Test Title'),
                validator: (value) => value!.isEmpty ? 'Enter a test title' : null,
                initialValue: _testTitle,
                onChanged: (value) => _testTitle = value,
              ),
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
                          validator: (value) => value!.isEmpty ? 'Enter a heading' : null,
                          initialValue: field.headingText,
                          onChanged: (value) => field.headingText = value,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Style for heading
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
                            _buildOptionField(field, 'Option 1', 1),
                            _buildOptionField(field, 'Option 2', 2),
                            _buildOptionField(field, 'Option 3', 3),
                            _buildOptionField(field, 'Option 4', 4),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Score'),
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty ? 'Enter the score' : null,
                              initialValue: field.score?.toString(),
                              onChanged: (value) => field.score = int.tryParse(value),
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
              field.correctOption = _getOptionText(field, optionNumber); // Update correctOption
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

  Future<void> _pickImage(DynamicField field) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Field'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Text'),
                onTap: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.text));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Image'),
                onTap: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.image));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('MCQ'),
                onTap: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.mcq));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Heading'),
                onTap: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.heading));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
