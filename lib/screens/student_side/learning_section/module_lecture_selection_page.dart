import 'package:e_learning_application/screens/student_side/learning_section/student_topics_list_page.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_application/services/default_learning_modules/module_widgets/module_screen.dart';
import 'package:e_learning_application/services/default_learning_modules/module_1/module1_sections.dart';
import 'student_topics_list_page.dart';
import 'module_list.dart';


class LearningModeSelection extends StatelessWidget {

  LearningModeSelection();


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',
        style: Theme.of(context).appBarTheme.titleTextStyle,),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionTile(
              context: context,
              icon: Icons.book,
              title: 'Learning Modules',
              subtitle: 'Tap to explore learning modules',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModulesListPage(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTile(
              context: context,
              icon: Icons.assignment,
              title: 'Faculty Lectures',
              subtitle: 'Tap to explore faculty lectures',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicsListPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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
  }
}

