import 'package:flutter/material.dart';
import 'package:e_learning_application/widgets/notes_taking/note_taking_dialog.dart';

class NotesButton extends StatelessWidget {
  final String contextTag; // e.g., Chapter ID or Page Tag

  const NotesButton({Key? key, required this.contextTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AddNoteDialog(contextTag: contextTag),
        );
      },
      child: Icon(Icons.edit_note),
      backgroundColor: Colors.teal, // Match your app's theme
    );
  }
}
