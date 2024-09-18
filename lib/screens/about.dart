import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome to Pulpath!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.0),
            Text(
              'Pulpath is an innovative e-learning application designed specifically for dental students. Our goal is to enhance the learning experience through interactive 3D models, comprehensive chapters, and effective testing methods. The app integrates modern educational techniques to make studying more engaging and efficient.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            //SizedBox(height: 24.0),
            // Text(
            //   'Meet the Team',
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
            //SizedBox(height: 8.0),
            // Text(
            //   'This application was developed in collaboration with:\n\n'
            //       '- **[Your Name]**: [Your role or contribution]\n'
            //       '- **[Friend\'s Name]**: [Your friend\'s role or contribution]\n'
            //       '- **[Dentist\'s Name]**: Medical Expert and Collaborator\n'
            //       '- **[Supervisor\'s Name]**: Guidance and Supervision',
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
            SizedBox(height: 24.0),
            Text(
              'Our Vision',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              'Our mission is to provide accessible, high-quality dental education that improves learning outcomes for students. We are committed to continuously expanding and enhancing our app to meet the evolving needs of dental education.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.0),
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              '• Interactive 3D Dental Models\n'
                  '• Comprehensive Chapter Progress Tracking\n'
                  '• Various Testing Formats with Feedback\n'
                  '• Dark and Light Mode Options',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.0),
            // Text(
            //   'Contact Us',
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
            SizedBox(height: 8.0),
            // Text(
            //   'We value your feedback! For support or suggestions, please reach out to us at:\n'
            //       'Email: support@pulpathapp.com\n'
            //       'Website: www.pulpathapp.com\n'
            //       'Follow us on social media for updates and news.',
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
          ],
        ),
      ),
    );
  }
}
