import 'package:flutter/material.dart';
import 'package:e_learning_application/widgets/notes_taking/note_taking_dialog.dart';

class MovableNotesButton extends StatefulWidget {
  final String contextTag; // e.g., Chapter ID or Page Tag

  const MovableNotesButton({Key? key, required this.contextTag})
      : super(key: key);

  @override
  _MovableNotesButtonState createState() => _MovableNotesButtonState();
}

class _MovableNotesButtonState extends State<MovableNotesButton> {
  // Initial position of the button
  Offset position = Offset(425, 450);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                position = Offset(
                  position.dx + details.delta.dx,
                  position.dy + details.delta.dy,
                );
              });
            },
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddNoteDialog(contextTag: widget.contextTag),
                );
              },
              child: Icon(Icons.edit_note),
              backgroundColor: Colors.teal, // Match your app's theme
            ),
          ),
        ),
      ],
    );
  }
}
