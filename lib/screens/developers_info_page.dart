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
              'Pulpath is project developed by the students of Bahria University (Lahore),under the supervision of Dr. Iram Noreen and co-supervision of Dr. Asifa Iqbal',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
