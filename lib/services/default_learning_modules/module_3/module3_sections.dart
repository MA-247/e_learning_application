import '../module_widgets/module_section.dart';

final List<ModuleSection> module3Sections = [
  // **Scenario Introduction**
  ModuleSection(
    type: SectionType.paragraph,
    content: "Scenario 1: Bicycle Accident",
    contentParts: [
      {"type": "heading", "text": "Scenario Introduction"},
      {
        "type": "paragraph",
        "text": """A 12-year-old child was brought to the clinic after falling off a bicycle. The child presented with a chipped front tooth and minor bleeding around the gums. The parent mentioned that the child was in pain and had difficulty eating. This module explores how to diagnose and manage various types of dental trauma.""",
      },
    ],
  ),

  // **Question Section**
  ModuleSection(
    type: SectionType.question,
    content: "What type of dental trauma does this case most likely represent?",
    options: [
      "Enamel Fracture",
      "Enamel-Dentin Fracture",
      "Pulpal Exposure",
      "Luxation Injury",
    ],
    correctAnswers: [
      "Enamel-Dentin Fracture",
    ],
  ),

  // **Table Section**
  ModuleSection(
    type: SectionType.table,
    content: "Classification of Dental Trauma",
    tableData: [
      ["CATEGORY", "EXAMPLES"], // Table headers
      ["Fractures", "Enamel, Enamel-Dentin, Crown-Root Fractures"],
      ["Luxations", "Concussion, Subluxation, Extrusion, Intrusion"],
      ["Avulsions", "Complete displacement of the tooth from its socket"],
    ],
  ),

  // **Paragraph Section**
  ModuleSection(
    type: SectionType.paragraph,
    content: "Immediate Management",
    contentParts: [
      {"type": "heading", "text": "Steps to Take Immediately After Trauma"},
      {
        "type": "paragraph",
        "text": """The parent was advised to rinse the child’s mouth with clean water and apply a cold compress to reduce swelling. For the chipped tooth, the importance of storing any broken fragments in milk or saline was explained. Immediate pain management was provided, and an X-ray was scheduled to evaluate the extent of the damage.""",
      },
      {
        "type": "paragraph",
        "text": """Education on the importance of prompt treatment was emphasized, especially in cases of avulsion where re-implantation within an hour greatly improves prognosis.""",
      },
    ],
  ),

  // **3D Model Section**
  ModuleSection(
    type: SectionType.model3D,
    content: "Visualizing Dental Trauma",
    modelUrls: [
      "https://ma-247.github.io/pulpath_3d_models_extras/cross.glb",
    ],
    xrayUrls: [
      "assets/module_3/x_rays/cracked.png",

    ],
  ),

  // **Second Question Section**
  ModuleSection(
    type: SectionType.question,
    content: "Which treatment is most suitable for an avulsed permanent tooth?",
    options: [
      "Immediate Re-implantation",
      "Extraction and Dentures",
      "Antibiotic Coverage Only",
      "Orthodontic Correction",
    ],
    correctAnswers: [
      "Immediate Re-implantation",
    ],
  ),

  // **References Section**
  ModuleSection(
    type: SectionType.references,
    content: "Further Reading",
    resources: [
      "https://www.aae.org/patients/dental-trauma/",
      "https://www.dentaltraumaguide.org/",
      "https://www.who.int/news-room/fact-sheets/detail/oral-health",
    ],
  ),
];
