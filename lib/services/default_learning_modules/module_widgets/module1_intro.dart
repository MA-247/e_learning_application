import 'module_section.dart';

final List<ModuleSection> module1Sections = [
  // Heading and Intro Text
  ModuleSection(
    type: SectionType.heading,
    content: 'Introduction to Oral Pathology',
  ),
  ModuleSection(
    type: SectionType.paragraph,
    content:
    'After finishing my assignment of the first chapter of oral pathology till late night, '
        'I slept peacefully but I heard the cries of my younger sister due to acute pulpitis asking for help...'
        '\nMy mother gave her some painkiller which was prescribed by our dentist.',
  ),

  // Multiple Choice Question
  ModuleSection(
    type: SectionType.question,
    content: 'Which type of disease is this?',
    options: [
      'Acute reversible pulpitis',
      'Acute irreversible pulpitis',
      'Chronic hyper-plastic pulpitis',
      'Chronic pulpitis'
    ],
  ),

  // EMQ Section
  ModuleSection(
    type: SectionType.emq,
    content:
    'What do you think about the cause of this pain? (Match each label)',
    options: [
      'Tooth with caries',
      'Cracked Tooth',
      'Gum diseases',
    ],
  ),

  // Consultation Section
  ModuleSection(
    type: SectionType.consultation,
    content:
    'I took my sister to the diagnostic department... the dental surgeon took the history...',
  ),

  // 3D Model Section
  ModuleSection(
    type: SectionType.model3D,
    content: 'Review the x-ray',
    modelUrls: ['assets/models/tooth_3d.obj',
    'assets/maxillary_first_molar_with_cusp_of_carabelli.glb'], // Placeholder for 3D model
  ),

  // References
  ModuleSection(
    type: SectionType.references,
    content: 'Further reading and references:',
    resources: [
      'https://dentalpathology.org/',
      'https://example.com/dental_material.pdf',
    ],
  ),
];
