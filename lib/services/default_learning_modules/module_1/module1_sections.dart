import "package:flutter/material.dart";
import '../module_widgets/module_section.dart';

final List<ModuleSection> module1Sections = [

  ModuleSection(
    type: SectionType.paragraph,
    content: "Scenario 1",
    contentParts: [
      {"type" : "heading",
      "text" : "Module 1"},

      {"type" : "paragraph",
      "text" : """After finishing my assignment of first chapter of oral pathology of oral pathology till late night, I slept peacefully but I heard the cries of my    younger sister due to acute pulpitis asking for help. I tried to figure out which tooth she is having pain by asking her and looking into her mouth but could not figure it out. My mother gave her some energizic which was prescribed by our dentist to my mother for tooth ache last week.
  My sister calmed down after few minutes but the pain was not completely gone. 
  I started to search about the what led to her having this acute pain. When I explored further, I found there are other causes for the pain than caries.
    """}
    ],
  ),
  ModuleSection(
    type: SectionType.question,
    content: 'Which type of disease this is?',
    options: [
      "acute reversible pulpitis",
      "acute irreversible",
      "chronic hyper-plastic pulpitis",
      "chronic pulpitis",

    ],
    correctAnswers: [
      "acute irreversible"
    ]
  ),

  ModuleSection(
    type: SectionType.emq,
      content: "What do you think about cause of this pain:",
      images: [
        "assets/module_1/emq_1/decaying_tooth.jfif",
        "assets/module_1/emq_1/tooth_filling.jfif",
        "assets/module_1/emq_1/gum_disease.jfif",
      ],
    labels: [
      "Gum Disease",
      "Tooth Filling",
      "Decaying Tooth",
    ],
    correctAnswers: [
      "Decaying Tooth",
      "Tooth Filling",
      "Gum Disease",
    ],
  ),

  ModuleSection(
    type: SectionType.paragraph,
    content: "Testing",
    contentParts: [
      {'type': 'heading', 'text': 'Consultation in the dental clinic'},
      {
        'type': 'paragraph',
        'text':
        "I took my sister to the diagnostic department of my teaching institution. The attending dental surgeon took the history of the condition; he asked my sister about the same complaint of the past and according to her, he had occasional sensitivity with hot and cold food and drinks. But she was not aware of any cavitation in her tooth.",
      },
      {
        'type': 'paragraph',
        'text':
        "When the dental surgeon percussed the tooth mirror handle, there was no significant reaction from my sister. After we did probing, they showed us that there is a catch in her occlusal surface of the right first upper molar tooth.",
      },
      {
        'type': 'paragraph',
        'text':
        "A periapical X-ray was done. At this point, I was able to relate what we discuss while studying dental caries and pulp.",
      },
    ],
  ),


  ModuleSection(
    type: SectionType.model3D,
    content: "Healthy Tooth",
    modelUrl: "assets/decaying_tooth_1.glb",
  ),

  ModuleSection(
    type: SectionType.references,
    content: "Further Reading",
    resources: ["www.google.com",],
  ),

];

