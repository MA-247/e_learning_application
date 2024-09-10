import 'package:flutter/material.dart';

class EnhancedDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final void Function(String?)? onChanged;

  const EnhancedDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0), // Match text field radius
        color: Colors.grey.shade200,
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        hint: const Text('Select University'),
        items: items.map((String university) {
          return DropdownMenuItem<String>(
            value: university,
            child: Text(
              university,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Match text field padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0)
          ), // Remove border to match text fields
        ),
      ),
    );
  }
}
