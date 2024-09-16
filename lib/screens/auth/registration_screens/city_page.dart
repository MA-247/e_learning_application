import 'package:flutter/material.dart';

class CityPage extends StatelessWidget {
  final TextEditingController cityController;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CityPage({Key? key, required this.cityController, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your City')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
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
