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
  String _testTitle = '';

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
          _testTitle = testData['title'] ?? '';
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
                  ..score = fieldData['score'];
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
                'score': field.score,
              };
            case FieldType.heading:
              return {'type': 'heading', 'content': field.headingText};
            default:
              return <String, dynamic>{};
          }
        }).toList();

        await FirebaseFirestore.instance.collection('tests').doc(widget.testId).update({
          'title': _testTitle,
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
    // Fetch the theme data
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Test', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.primaryColor,  // Use the theme's primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: _inputDecoration('Test Title', theme),
                validator: (value) => value!.isEmpty ? 'Enter a test title' : null,
                initialValue: _testTitle,
                onChanged: (value) => _testTitle = value,
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
                          decoration: _inputDecoration('Heading', theme),
                          validator: (value) => value!.isEmpty ? 'Enter a heading' : null,
                          initialValue: field.headingText,
                          onChanged: (value) => field.headingText = value,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                            : field.type == FieldType.text
                            ? TextFormField(
                          decoration: _inputDecoration('Text', theme),
                          validator: (value) => value!.isEmpty ? 'Enter text' : null,
                          initialValue: field.text,
                          onChanged: (value) => field.text = value,
                        )
                            : field.type == FieldType.image
                            ? Column(
                          children: [
                            field.image != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                field.image!,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                                : ElevatedButton.icon(
                              onPressed: () => _pickImage(field),
                              icon: Icon(Icons.upload_file),
                              label: Text('Upload Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.scaffoldBackgroundColor,  // Use accent color
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                              decoration: _inputDecoration('Question', theme),
                              validator: (value) => value!.isEmpty ? 'Enter a question' : null,
                              initialValue: field.question,
                              onChanged: (value) => field.question = value,
                            ),
                            SizedBox(height: 10,),
                            _buildOptionField(field, 'Option 1', 1, theme),
                            SizedBox(height: 10,),
                            _buildOptionField(field, 'Option 2', 2, theme),
                            SizedBox(height: 10,),
                            _buildOptionField(field, 'Option 3', 3, theme),
                            SizedBox(height: 10,),
                            _buildOptionField(field, 'Option 4', 4, theme),
                            SizedBox(height: 10,),
                            TextFormField(
                              decoration: _inputDecoration('Score', theme),
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty ? 'Enter the score' : null,
                              initialValue: field.score?.toString(),
                              onChanged: (value) => field.score = int.tryParse(value),
                            ),
                          ],
                        )
                            : Container(),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: theme.primaryColor),
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
                  backgroundColor: theme.scaffoldBackgroundColor,  // Use accent color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadTest,
                child: Text('Save Test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,  // Use primary color
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build input decoration
  InputDecoration _inputDecoration(String label, ThemeData theme) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.textTheme.bodyLarge?.color),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.primaryColor),
      ),
    );
  }

  // Method to build MCQ option input
  Widget _buildOptionField(DynamicField field, String label, int optionNumber, ThemeData theme) {
    return TextFormField(
      decoration: _inputDecoration(label, theme),
      validator: (value) => value!.isEmpty ? 'Enter an option' : null,
      initialValue: optionNumber == 1 ? field.option1 :
      optionNumber == 2 ? field.option2 :
      optionNumber == 3 ? field.option3 : field.option4,
      onChanged: (value) {
        if (optionNumber == 1) {
          field.option1 = value;
        } else if (optionNumber == 2) {
          field.option2 = value;
        } else if (optionNumber == 3) {
          field.option3 = value;
        } else {
          field.option4 = value;
        }
      },
    );
  }

  // Method to pick image for field
  Future<void> _pickImage(DynamicField field) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        field.image = File(image.path);
      });
    }
  }

  // Method to remove a field
  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  // Method to show Add Field dialog
  void _showAddFieldDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Field Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.text));
                  });
                  Navigator.pop(context);
                },
                child: Text('Text'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.image));
                  });
                  Navigator.pop(context);
                },
                child: Text('Image'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.mcq));
                  });
                  Navigator.pop(context);
                },
                child: Text('MCQ'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _fields.add(DynamicField(type: FieldType.heading));
                  });
                  Navigator.pop(context);
                },
                child: Text('Heading'),
              ),
            ],
          ),
        );
      },
    );
  }
}
