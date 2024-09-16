import 'package:flutter/material.dart';

class UniversityPage extends StatefulWidget {
  final List<String> universities;
  final String? selectedUniversity;
  final ValueChanged<String?> onUniversitySelected;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const UniversityPage({
    Key? key,
    required this.universities,
    required this.selectedUniversity,
    required this.onUniversitySelected,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  _UniversityPageState createState() => _UniversityPageState();
}

class _UniversityPageState extends State<UniversityPage> {
  final TextEditingController _otherUniversityController = TextEditingController();
  bool _isOtherSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your University')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: widget.selectedUniversity,
              hint: Text('Select University'),
              items: widget.universities
                  .map((String university) {
                return DropdownMenuItem<String>(
                  value: university,
                  child: Text(university),
                );
              }).toList()
                ..add(
                  DropdownMenuItem<String>(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ),
              onChanged: (value) {
                setState(() {
                  _isOtherSelected = value == 'Other';
                  widget.onUniversitySelected(value);
                });
              },
            ),
            if (_isOtherSelected)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _otherUniversityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter University Name',
                  ),
                  onChanged: (value) {
                    widget.onUniversitySelected(value.isNotEmpty ? value : null);
                  },
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: widget.onBack,
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isOtherSelected) {
                      widget.onUniversitySelected(_otherUniversityController.text);
                    }
                    widget.onNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otherUniversityController.dispose();
    super.dispose();
  }
}
