import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNoteDialog extends StatefulWidget {
  final String contextTag;

  const AddNoteDialog({Key? key, required this.contextTag}) : super(key: key);

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;

  Future<void> saveNote() async {
    if (_noteController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the current user's ID from Firebase Authentication
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User not logged in');
        return;
      }

      // Save the note under the user's ID in the Firestore collection
      await FirebaseFirestore.instance
          .collection('users')  // Collection named 'users' for storing all users' data
          .doc(user.uid)        // Each user has their own document with the user's ID as the document ID
          .collection('notes')  // The notes collection specific to each user
          .add({
        'content': _noteController.text.trim(),
        'tag': widget.contextTag,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      print('Error saving note: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note'),
      content: TextField(
        controller: _noteController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Write your note here...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : saveNote,
          child: _isLoading
              ? CircularProgressIndicator(
            color: Colors.white,
          )
              : Text('Save'),
        ),
      ],
    );
  }
}
