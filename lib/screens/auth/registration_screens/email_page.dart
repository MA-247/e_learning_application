import 'package:flutter/material.dart';

class EmailPage extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EmailPage({Key? key, required this.emailController, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
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
