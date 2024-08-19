import 'dart:io';

enum FieldType { text, heading, image, mcq }

class DynamicField {
  FieldType type;
  String? text;
  File? image;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? correctOption;
  String? headingText;
  int? score; // Add this line

  DynamicField({
    required this.type,
    this.text,
    this.image,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.correctOption,
    this.headingText,
    this.score,
  });
}
