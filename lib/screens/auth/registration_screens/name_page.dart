import 'package:flutter/material.dart';

class NamePage extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onNext;

  const NamePage({Key? key, required this.nameController, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onNext,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
