import 'package:e_learning_application/screens/student_side/learning_section/student_topics_list_page.dart';
import 'package:flutter/material.dart';
import 'about.dart';
import 'developers_info_page.dart';

class AboutSection extends StatelessWidget {

  AboutSection();


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('About',
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
              title: 'About the Application',
              subtitle: 'Tap to view information about the app',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTile(
              context: context,
              icon: Icons.assignment,
              title: 'Developement Team',
              subtitle: 'Tap to view info regarding the development team',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DevelopersInfoPage(),
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

