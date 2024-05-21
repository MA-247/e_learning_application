import 'package:e_learning_application/models/chapters.dart';

class Topic {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String modelUrl;

  Topic({required this.id, required this.title, required this.description, required this.modelUrl, required this.subtitle});
}
