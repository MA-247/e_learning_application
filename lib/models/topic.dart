import 'package:e_learning_application/models/chapters.dart';

class Topic {
  final String id;
  final String title;
  final List<Chapter> chapters;

  Topic({required this.id, required this.title, required this.chapters});
}
