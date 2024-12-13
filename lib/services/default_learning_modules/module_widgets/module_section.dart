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
  audio, // New type for audio sections
  video, // New type for video sections
}

class ModuleSection {
  final SectionType type;
  final String content;
  final List<Map<String, String>>? contentParts; // For mixed content types
  final List<String>? options; // For questions/EMQs
  final String? heading;
  final String? imageUrl;
  final List<String>? imageUrls;
  final List<String>? modelUrls;
  final List<String>? xrayUrls;
  final List<String>? resources; // URLs for references
  final List<String>? images; // List of image URLs for EMQ section
  final List<String>? labels; // Labels for EMQ matching
  final List<String>? correctAnswers; // Correct answers for the EMQ labels
  final List<List<String>>? tableData; // Table data for structured content
  final List<String>? audioUrls; // Audio resources
  final List<String>? videoUrls; // Video resources
  final String? caption; // Caption for media or tables
  final Map<String, dynamic>? metadata; // Additional optional metadata
  final List<String>? interactionData; // For storing user responses or interactions
  final double? painScale; // Pain scale value for 3D models
  final List<int>? painLevels;

  ModuleSection({
    required this.type,
    required this.content,
    this.options,
    this.heading,
    this.imageUrl,
    this.modelUrls,
    this.imageUrls,
    this.resources,
    this.images,
    this.labels,
    this.correctAnswers,
    this.contentParts,
    this.tableData,
    this.audioUrls,
    this.videoUrls,
    this.caption,
    this.metadata,
    this.interactionData,
    this.painScale,
    this.painLevels,
    this.xrayUrls,
  });
}
