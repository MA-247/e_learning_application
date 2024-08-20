import 'dart:io';

enum FieldType { text, heading, image, mcq }

class DynamicField {
  FieldType type;
  String? text;
  String? headingText;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? correctOption;
  int? correctOptionNumber; // New property to store the selected correct option number
  int? score;
  File? image;

  DynamicField({required this.type});
}
