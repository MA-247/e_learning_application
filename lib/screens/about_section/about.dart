import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
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
              'Pulpath is an innovative e-learning application designed specifically for undergraduate dental students for the module of Pathogenesis of Pulp and Periapical Pathologies. Our goal is to enhance the learning experience through digital simulations and effective assessment methods. The app integrates modern educational techniques to make studying more engaging and efficient.',
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
              'Our mission is to provide accessible, advanced technology enhanced dental learning experience with the aim of better learning outcomes. We are committed to continuously enhancing our application based on our users feedback.',
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
            SizedBox(height: 24.0),
            Text(
              'Fiction Contract',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              "During the following virtual simulation, you will interact with characters and situations based on clinical encounters. Virtual simulation fosters an environment for active engagement in a relatively safe environment. As the creators of the virtual simulation, we do all that we can to make the simulation as accurate as possible. We do recognize that some aspects could be more realistic. As the learner, we would like to ask you to please engage in the simulation, with all the healthcare team members and the client, as if they were real. Using these simulated experiences this way provides you with an active learning opportunity.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.0),
            Text(
              'Confidentiality Contract',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0,),
            Text(
              "During the virtual simulation, we ask that you be non-judgmental and open to learning from the simulation. It is important to remember that what happens in the simulation stays in the simulation. Maintaining confidentiality related to the virtual simulation experiences and others' choices or comments you help create a psychologically safe learning environment and a practical experience for all learners.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.0),
            Text(
              'Psychological Safety and Sensitive Content',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0,),
            Text(
              "The following virtual simulation may have potentially disturbing content and is designed for learners. If you have any unsettled feelings during or after the virtual simulation, contact your educator or counselling services at your institution.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.0,),
            Text(
              "Learning Objectives",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              "student will be able to learn the pathogenesis of pulpitis and periapical pathology through digital simulations",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
