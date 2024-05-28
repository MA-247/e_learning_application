import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_application/models/topic.dart';
import 'package:e_learning_application/screens/topic_detail.dart';
import 'package:e_learning_application/widgets/custom_listTile.dart';
import 'package:e_learning_application/models/chapters.dart';

class LearningSection extends StatelessWidget {
  final User user;

  LearningSection({required this.user});

  @override
  Widget build(BuildContext context) {
    // Fetch and display the list of topics
    // For simplicity, using static data
    List<Chapter> chaptersTopic1 = [
      Chapter(id: '1', title: 'Innervation of the Dental Pulp and Dentin', description: '''The dental pulp resides in a rigid capsule consisting of dentin and enamel. This creates a low-compliant environment that makes the pulp tissue unique. The dental pulp is richly innervated mainly by axons from the trigeminal nerve, predominantly sensory in nature and mainly committed to pain perception (nociception). A smaller population of pulpal nerves are autonomic sympathetic fibers emanating from the superior cervical ganglion and associated with pulpal vasoconstriction.Extremely strong pain – reaching the maximum intensity at any pain score – can be induced by activation of intradental nerves. Such intense pain responses can be explained by the dense and predominantly nociceptive innervation of the pulp and dentin. The transmission of pain-inducing stimuli through dentin from its exposed surface is exceptionally effective, allowing even very light stimuli, such as air blasts and probing, to be intensified in a way that may induce tissue injury and subsequent nerve activation at the pulp-dentin border. Each tooth is innervated by about a thousand trigeminal axons, which may have branched before entering the apical foramen and may innervate more than one tooth. In the radicular pulp, the nerve fibers are bundled together, but once they reach the coronal pulp, they divide into smaller bundles. The axons then branch extensively, and each may form 50-100 terminals in the peripheral pulp, forming a network under the odontoblast layer, known as the plexus of Raschkow. The density of nerve endings is especially high in the pulp horns, where as many as 50% of the dentinal tubules are innervated. Many of the tubules contain multiple nerve terminals, with approximately 20,000-30,000 nociceptive nerve endings/mm² in the pulp-dentin border area in the most coronal pulp, which accounts for the extremely high sensitivity of dentin.''',
          modelUrl: 'assets/pHTooth.obj'),
      Chapter(id: '2', title: 'Nerve Fiber Types: A- and C-Fibers, Their Functional Differences', description: '''There are both myelinated (20-25%) and unmyelinated (75-80%) afferent nerve fibers in the pulp. These two fiber groups differ greatly in their functional properties. The myelinated fibers belong predominantly to the Aδ- but partly to the Aβ-group and are fast-conducting (from 3 up to 50-60 m/s). The A-fiber endings are located in the peripheral pulp and inner dentin. They are responsible for dentin sensitivity, and their activation in healthy teeth results in sharp and usually short-lasting pain, not outlasting the stimulus. 
There are also a number of larger Aδ-fibers (approximately 10%) that enter the pulp at the apex. These are not active in the healthy pulp but become active when inflammation is present. This is an example of ‘peripheral sensitization,’ when normally non-noxious nerve fibers are recruited to the pain system. All the sensory nerve fibers that enter the pulp branch and get narrower as they travel to the pulp cornua. Four times as many nerve fibers can be counted at the mid-crown level of the pulp than at the apical level. Myelinated nerve fibers commonly have non-myelinated terminals, making it difficult to differentiate the terminals of fast and slow fibers.
The non-myelinated nerves are C-fibers with slow conduction velocities (0.5-2.5 m/s), and their terminals are located in the pulp proper. They are predominantly sensory with a small population of sympathetics (10%). The majority (70%) of the axons entering the apex are C-fibers.
The C-fibers are polymodal and respond to several different noxious stimuli. In other sites, they are activated by intense heat and cold and many inflammatory mediators such as histamine and bradykinin. In the pulp, they are activated during inflammation, and increasingly so in its advanced stages. It seems from the clinical point of view that the activation of C-fibers, inducing dull aching pain that is often long-lasting or lingering in nature, may suggest that the pulp is irreversibly damaged and might need root canal treatment.
''',
          modelUrl: 'assets/pHTooth.obj'),
      Chapter(id: '2', title: 'Changes in Nerve Function in Inflammation, Neurogenic Inflammation, Inflammatory Mediators', description: '''Structural changes of nerve fibers occur in response to inflammation. Nerve fibers sprout or branch extensively, increasing the release of neuropeptides, resulting in “neurogenic inflammation.” CGRP and SP are increased at initial stages of pulpal inflammation, whereas NPY increases in chronic stages. Neuropeptides released from sensory neurons not only act on the vasculature but also directly attract and activate innate immune cells (dendritic cells) and adaptive immune cells (T lymphocytes). Once immune cells are recruited to the site of inflammation, inflammatory mediators such as cytokines, histamine, bradykinin, prostaglandins, leukotrienes, and numerous other substances are released. Neural sprouting increases neuropeptide content and release, resulting in neurogenic inflammation.

As caries progress, structural and functional changes occur in the dentin-pulp complex. For example, limited caries may already induce minor neurogenic inflammation and onset of dentin sclerosis, while deeper carious lesions may coincide with hyper- and thermal sensitivity of a tooth. Sprouting of sensory neuropeptide-containing nerve fibers occurs with deeper carious lesions and is reversible with caries arrestment or restoration. As caries progresses to the pulp, more severe structural changes occur, including micro-abscess formation, extensive nerve sprouting, and increased neuropeptide release. This can lead to pulpal necrosis and apical periodontitis if untreated.

Mechanism of Nerve Activation in Response to Dentinal Stimulation, Dentin Sensitivity

The transmission of stimuli from the peripheral dentin to the sensory terminals at the dentin-pulp border is influenced by the movement of fluid within the dentinal tubules, which is crucial for dentinal pain. Pain-producing stimuli displace fluid within the tubules, leading to mechanotransduction – the conversion of mechanical stimuli into electrical signals by mechanosensitive ion channels located in the axon terminals. The outward movement of fluid (negative pressure) produces a stronger nerve response than inward movements.
The hydrodynamic theory explains dentinal pain through fluid movement within dentinal tubules, translating into electrical signals by activating mechanosensitive ion channels. This mechanism is supported by evidence showing a positive correlation between pressure change and nerve impulses from the pulp. Thermal stimuli (cold or heat) can evoke pain, with fluid movement in tubules being a significant factor. A-fibers are primarily activated by rapid tubular content displacement, while C-fibers are activated by heat above 43°C and certain inflammatory mediators.
Treatment of dentin hypersensitivity includes improving oral hygiene to remove biofilm and possibly treating the area to reduce dentin permeability. In cases of carious lesions or irreversible pulpitis, endodontic therapy might be necessary. Addressing both the neural and inflammatory aspects of pulpal and dentinal pain is crucial for effective pain management.
''',
          modelUrl: 'assets/pHTooth.obj'),
    ];
    List<Topic> topics = [
      Topic(id: '1', title: 'Acute Dental Pain I: Pulpal and Dentinal Pain', chapters: chaptersTopic1),
      //Topic(id: '2', title: 'Topic 2', chapters: chapters),
      // Other topics
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Learning Section',
      style: TextStyle(
        color: Colors.white,

      ),),
      backgroundColor: Colors.blue[300],),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return CustomListTile(
            title: topic.title,
            subtitle: "Just Checking",
            topic: topic,
          );
        },
      ),
    );
  }
}
