enum SectionType {
  heading,
  paragraph,
  question,
  emq,
  consultation,
  model3D,
  references,
  contentParts,
}

class ModuleSection {
  final SectionType type;
  final String content;
  final List<Map<String, String>>? contentParts; // For mixed content types
  final List<String>? options; // For questions/EMQs
  final String? heading;
  final String? imageUrl;
  final String? modelUrl;
  final List<String>? resources; // URLs for references
  final List<String>? images; // List of image URLs for EMQ section
  final List<String>? labels; // Labels for EMQ matching
  final List<String>? correctAnswers; // Correct answers for the EMQ labels



  ModuleSection({
    required this.type,
    required this.content,
    this.options,
    this.heading,
    this.imageUrl,
    this.modelUrl,
    this.resources,
    this.images,
    this.labels,
    this.correctAnswers,
    this.contentParts,
  });
}

