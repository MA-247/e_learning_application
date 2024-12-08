import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String content;
  final Timestamp timestamp;

  Note({
    required this.id,
    required this.content,
    required this.timestamp,
  });

  // Convert Firestore document to Note model
  factory Note.fromDocument(DocumentSnapshot doc) {
    return Note(
      id: doc.id,
      content: doc['content'],
      timestamp: doc['timestamp'],
    );
  }
}
