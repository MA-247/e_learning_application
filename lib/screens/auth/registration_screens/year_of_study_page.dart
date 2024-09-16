import 'package:flutter/material.dart';

class YearOfStudyPage extends StatelessWidget {
  final TextEditingController yearOfStudyController;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const YearOfStudyPage({Key? key, required this.yearOfStudyController, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Year of Study')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: yearOfStudyController,
              decoration: InputDecoration(labelText: 'Year of Study'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onBack,
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: onNext,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
