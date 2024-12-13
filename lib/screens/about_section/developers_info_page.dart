import 'package:flutter/material.dart';

class DevelopersInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet the Developers'),
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
              'Pulpath is a collaborative effort by a passionate team of developers, mentors, and a real-time client, designed to deliver an engaging and interactive experience for users.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.0),
            Text(
              'Developers:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8.0),
            _buildDeveloperInfo(context, 'Sheheryar Sohail', 'sohailsheheryar226@gmail.com', 'A dedicated developer with a strong focus on crafting seamless and user-friendly features.'),
            SizedBox(height: 16.0),
            _buildDeveloperInfo(context, 'Murtaza Anwaar ul Haq Hashmi', 'murtazaanwaar@gmail.com', 'A creative developer committed to building efficient and innovative solutions.'),
            SizedBox(height: 24.0),
            Text(
              'Supervisor:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8.0),
            _buildDeveloperInfo(context, 'Dr. Iram Noreen', 'iram.bulc@bahria.edu.pk', 'Providing expert guidance and valuable insights to ensure the success of Pulpath.'),
            SizedBox(height: 24.0),
            Text(
              'Real-Time Client and Collaborator:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8.0),
            _buildDeveloperInfo(context, 'Dr. Asifa Iqbal', '', 'A dentist who played a vital role in Pulpath by collaborating with the team and providing comprehensive dentistry data, ensuring the application meets real-world needs.'),
            SizedBox(height: 24.0),
            Text(
              'We strive to create impactful solutions through teamwork and innovation!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperInfo(BuildContext context, String name, String email, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (email.isNotEmpty)
          Text(
            'Email: $email',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
