enum SectionType {
  heading,
  paragraph,
  question,
  emq,
  consultation,
  model3D,
  references,
  contentParts,
  table,
}

class ModuleSection {
  final SectionType type;
  final String content;
  final List<Map<String, String>>? contentParts; // For mixed content types
  final List<String>? options; // For questions/EMQs
  final String? heading;
  final String? imageUrl;
  final List<String>? modelUrls;
  final List<String>? resources; // URLs for references
  final List<String>? images; // List of image URLs for EMQ section
  final List<String>? labels; // Labels for EMQ matching
  final List<String>? correctAnswers; // Correct answers for the EMQ labels
  final List<List<String>>? tableData;


  ModuleSection({
    required this.type,
    required this.content,
    this.options,
    this.heading,
    this.imageUrl,
    this.modelUrls,
    this.resources,
    this.images,
    this.labels,
    this.correctAnswers,
    this.contentParts,
    this.tableData, // Initialize tableData
  });
}

