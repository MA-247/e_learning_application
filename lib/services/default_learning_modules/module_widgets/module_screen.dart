import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'module_section.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModuleScreen extends StatefulWidget {
  final List<ModuleSection> sections;

  const ModuleScreen({Key? key, required this.sections}) : super(key: key);

  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  int currentIndex = 0; // Start from the first section
  Map<int, String> userMatches = {}; // Store user label selections for EMQ

  void _nextSection() {
    if (currentIndex < widget.sections.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _previousSection() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    ModuleSection currentSection = widget.sections[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Oral Pathology'),
      ),
      body: Column(
        children: [
          // Main content area: Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionContent(currentSection), // Section content
                ],
              ),
            ),
          ),

          // Navigation buttons fixed at the bottom
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white, // Add a background color if needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  ElevatedButton(
                    onPressed: _previousSection,
                    child: Text('Previous'),
                  )
                 else
                    SizedBox(width: 100),
                if (currentIndex < widget.sections.length - 1)
                  ElevatedButton(
                    onPressed: _nextSection,
                    child: Text('Next'),
                  ),
                if (currentIndex == widget.sections.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      // Implement any action when the module is completed
                      Navigator.pop(context); // Or navigate to another screen
                    },
                    child: Text('Finish'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Method to display content based on section type
  Widget _buildSectionContent(ModuleSection section) {
    switch (section.type) {
      case SectionType.heading:
        return Text(
          section.content,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
      case SectionType.references:
        return _buildReferencesSection(context, section.resources ?? []);

      case SectionType.paragraph:
      // Handle mixed headings and paragraphs
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var part in section.contentParts ?? [])
              if (part['type'] == 'heading')
                Text(
                  part['text'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              else if (part['type'] == 'paragraph')
                Text(
                  part['text'] ?? '',
                  textAlign: TextAlign.justify, // Justify the paragraph text
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
          ],
        );

      case SectionType.question:
        return _buildQuestionSection(section);
      case SectionType.emq:
        return _buildEMQSection(section); // EMQ section
      case SectionType.model3D:
        return _build3DModelSection(section);
      case SectionType.table:
        return _buildTableSection(section);
      default:
        return Container();
    }
  }


  // Method to build a question section
  Widget _buildQuestionSection(ModuleSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the question content
        Text(section.content, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        // Display options as ListTiles
        for (var option in section.options ?? [])
          ListTile(
            title: Text(option),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Check if the selected option is correct
                bool isCorrect = section.correctAnswers?.contains(option) ?? false;

                // Show the result in a dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(isCorrect ? 'Correct Answer!' : 'Wrong Answer'),
                    content: Text(
                      isCorrect
                          ? """You selected: $option\n\nThis is the correct answer."""
                          : """You selected: $option\n\nThe correct answer is: ${section.correctAnswers?.join(', ')}""",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }


  // Handle EMQ section (Extended Matching Question)
  Widget _buildEMQSection(ModuleSection section) {
    if (section.images == null || section.labels == null) {
      return Center(
        child: Text('No data available for this section'),
      );
    }

    // Ensure userMatches aligns with the number of images
    final List<String?> userMatches = List<String?>.filled(section.images!.length, null);

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section content (instructions or description)
                if (section.content.isNotEmpty)
                  Text(
                    section.content,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                const SizedBox(height: 10),

                // Display the images and labels
                for (int i = 0; i < section.images!.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display image for this section
                      Image.asset(
                        section.images![i],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error, size: 100, color: Colors.red),
                      ),
                      const SizedBox(height: 10),

                      // Instruction for matching
                      Text(
                        'Match the label for this image:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      // Drag and Drop labels
                      Wrap(
                        spacing: 8.0, // Adjust spacing between labels
                        runSpacing: 8.0, // Adjust vertical spacing
                        children: [
                          for (var label in section.labels!)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userMatches[i] = label; // Save user selection
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: userMatches[i] == label
                                      ? (label == section.correctAnswers?[i]
                                      ? Colors.green
                                      : Colors.red)
                                      : Colors.white,
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: userMatches[i] == label
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                // Spacer between labels and correct answers
                const SizedBox(height: 20),

                // Display correct answers after all labels are matched
                if (userMatches.every((match) => match != null))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Correct Answers:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      for (int i = 0; i < section.images!.length; i++)
                        Text(
                          'Image ${i + 1}: ${section.correctAnswers?[i] ?? "No correct answer provided"}',
                          style: TextStyle(
                            color: userMatches[i] == section.correctAnswers?[i]
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }





  // Handle X-Ray or other custom section types as needed
  Widget _buildXRaySection(ModuleSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display your 3D model or X-ray here (for example, using an image)
        Image.asset(section.content), // Example for displaying X-ray image
      ],
    );
  }
}

Widget _build3DModelSection(ModuleSection section) {
  final modelUrls = section.modelUrls ?? [];
  final allXrayUrls = section.xrayUrls ?? [];
  final painLevels = section.painLevels ?? (List.filled(modelUrls.length, 0));

  if (modelUrls.isEmpty) {
    return Center(
      child: Text(
        'No 3D models available.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  int modelCurrentIndex = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      // Get the X-ray images corresponding to the current model index
      final xrayUrls = allXrayUrls.take(modelCurrentIndex + 1).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Caries Progression',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 400,
            child: Container(
              height: 400,
              child: ModelViewer(
                key: ValueKey(modelUrls[modelCurrentIndex]),
                src: modelUrls[modelCurrentIndex], // Ensure this URL is correct and points to a valid model
                autoRotate: false,
                cameraControls: true,
                interactionPrompt: InteractionPrompt.auto,
                poster: "assets/logos/PULPATH_logo.jpg", // Optional, fallback image
                maxHotspotOpacity: 0.25,
                minHotspotOpacity: 0.35,
                cameraOrbit: "0deg 75deg 2m",
                fieldOfView: "45deg",
              ),
            )

          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: modelCurrentIndex > 0
                    ? () {
                  setState(() {
                    modelCurrentIndex--;
                  });
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: modelCurrentIndex < modelUrls.length - 1
                    ? () {
                  setState(() {
                    modelCurrentIndex++;
                  });
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Horizontal Pain Scale
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Pain Scale (Static)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(11, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 16,
                            color: index <= painLevels[modelCurrentIndex]
                                ? Colors.red
                                : Colors.grey,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$index',
                            style: TextStyle(
                              fontSize: 12,
                              color: index <= painLevels[modelCurrentIndex]
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pain Level: ${painLevels[modelCurrentIndex]}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Drawer for X-rays: Updated to display progressively
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'X-rays for Model ${modelCurrentIndex + 1}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: xrayUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            // Optional: Add logic for highlighting selected X-ray
                          },
                          child: Image.network(
                            xrayUrls[index],
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}









Widget _buildReferencesSection(BuildContext context, List<String> resources) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Further Reading:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      const SizedBox(height: 10),
      for (var resource in resources)
        GestureDetector(
          onTap: () async {
            if (await canLaunch(resource)) {
              await launch(resource);
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('Could not open the link.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Text(
            resource,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
    ],
  );
}


Widget _buildTableSection(ModuleSection section) {
  // Extracting table data from the ModuleSection
  List<List<String>>? tableData = section.tableData;

  // Ensure that tableData is available and contains the data we need for the table
  if (tableData == null || tableData.isEmpty) {
    return SizedBox(); // Return an empty widget if no table data is available
  }

  // Extracting table headers (the first row is assumed to be headers)
  List<String> tableHeaders = tableData[0];

  // Extracting rows (data rows are assumed to be all rows except the first one)
  List<DataRow> rows = [];
  for (int i = 1; i < tableData.length; i++) {
    rows.add(DataRow(
      cells: tableData[i].map((cell) => DataCell(Text(cell))).toList(),
    ));
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        // Check if there are table headers, then create the table
        if (tableHeaders.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: tableHeaders
                  .map((header) => DataColumn(label: Text(header)))
                  .toList(),
              rows: rows,
              border: TableBorder.all(color: Colors.teal, width: 1),

            ),
          ),
      ],
    ),
  );
}


