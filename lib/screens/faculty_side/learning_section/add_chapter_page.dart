import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChapterPage extends StatefulWidget {
  @override
  _AddChapterPageState createState() => _AddChapterPageState();
}

class _AddChapterPageState extends State<AddChapterPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool _isLoading = false;

  Future<void> _addChapter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true; // Show loading state
      });

      try {
        await FirebaseFirestore.instance.collection('chapters').add({
          'title': _title,
          'description': _description,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chapter added successfully!')),
        );

        Navigator.of(context).pop(); // Navigate back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add chapter: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading state
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
                  _title = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addChapter,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal[300],
                  ),
                  child: Text(
                    _isLoading ? 'Adding...' : 'Add Chapter',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
