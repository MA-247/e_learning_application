import 'package:e_learning_application/services/default_learning_modules/module_2/module2_sections.dart';
import 'package:e_learning_application/services/default_learning_modules/module_3/module3_sections.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_application/services/default_learning_modules/module_widgets/module_screen.dart';
import 'package:e_learning_application/services/default_learning_modules/module_1/module1_sections.dart';

class ModulesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example modules list with sections
    final List<Map<String, dynamic>> modules = [
      {'title': 'Module 1', 'description': 'Pulpitis', 'sections': module1Sections},
      {'title' : 'Module 2', 'description' : 'Periodontal Disease', 'sections' : module2Sections},
      {'title' : 'Module 3', 'description' : 'Dental Trauma and Its Management', 'sections' : module3Sections},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Modules'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return GestureDetector(
            onTap: () {
              // Navigate to ModuleScreen with respective sections
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleScreen(sections: module['sections']),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            module['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
