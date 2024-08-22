class Chapter {
  final String id;
  final String title;
  final String description;
  final String? modelUrl;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    this.modelUrl,
  });
}
