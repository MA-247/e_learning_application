import '../module_widgets/module_section.dart';

final List<ModuleSection> module2Sections = [
  ModuleSection(
    type: SectionType.paragraph,
    content: "Scenario 1",
    contentParts: [
      {"type": "heading", "text": "Scenario Introduction"},
      {
        "type": "paragraph",
        "text": """While enjoying an evening snack, I noticed my father complaining of bleeding gums. Upon closer observation, I found swelling and redness around his gums. He mentioned occasional bad breath and discomfort while eating. Concerned, I decided to investigate the causes and possible treatments for periodontal disease.""",
      },
    ],
  ),
  ModuleSection(
    type: SectionType.question,
    content: "Which stage of periodontal disease might this be?",
    options: [
      "Gingivitis",
      "Early Periodontitis",
      "Moderate Periodontitis",
      "Advanced Periodontitis",
    ],
    correctAnswers: [
      "Gingivitis",
    ],
  ),
  ModuleSection(
    type: SectionType.emq,
    content: "What could be contributing to his symptoms?",
    images: [
      "assets/module_2/emq_2/plaque.jpg",
      "assets/module_2/emq_2/tobacco.jpg",
    ],
    labels: [
      "Plaque Buildup",
      "Tobacco Use",
    ],
    correctAnswers: [
      "Plaque Buildup",
      "Tobacco Use",
    ],
  ),
  ModuleSection(
    type: SectionType.table,
    content: "Common Risk Factors for Periodontal Disease",
    tableData: [
      ["CATEGORY", "EXAMPLES"], // Table headers
      ["Oral Hygiene", "Plaque, Tartar"],
      ["Lifestyle", "Smoking, Alcohol"],
      ["Systemic", "Diabetes, Osteoporosis"],
      ["Genetic", "Family History of Gum Disease"],
      ["Others", "Stress, Age"],
    ],
  ),
  ModuleSection(
    type: SectionType.paragraph,
    content: "Clinical Examination",
    contentParts: [
      {"type": "heading", "text": "Dental Clinic Visit"},
      {
        "type": "paragraph",
        "text": """We visited the periodontal department at a local clinic. The dentist examined the gums using a periodontal probe. Pocket depths of more than 3 mm were recorded in some areas. The dentist also noted bleeding on probing and provided detailed advice on treatment options and preventive care.""",
      },
      {
        "type": "paragraph",
        "text": """Radiographs showed bone loss in certain regions. I learned how regular brushing, flossing, and professional cleaning could prevent further progression.""",
      },
    ],
  ),
  ModuleSection(
    type: SectionType.references,
    content: "Further Reading",
    resources: [
      "https://www.perio.org",
      "https://www.mouthhealthy.org",
    ],
  ),
];
