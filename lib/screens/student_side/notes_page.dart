import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/widgets/notes_taking/notes_model.dart'; // Import the Note model

class NoteDetailPage extends StatefulWidget {
  final Note note;

  NoteDetailPage({required this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool _isLoading = false;

  // Function to delete the note
  Future<void> _deleteNote(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .doc(widget.note.id) // Use the unique ID of the note
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note deleted successfully')),
      );

      Navigator.pop(context); // Navigate back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete note: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            tooltip: "Delete Note",
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Note'),
                  content: Text('Are you sure you want to delete this note?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                _deleteNote(context);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timestamp: ${widget.note.timestamp.toDate()}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.note.content,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) // Show loading overlay if loading
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
