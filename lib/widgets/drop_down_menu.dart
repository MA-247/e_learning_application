import 'package:flutter/material.dart';

class EnhancedDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final void Function(String?)? onChanged;
  final Color? dropdownColor; // Added parameter
  final String hintText; // Added parameter for hint text

  const EnhancedDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.dropdownColor, // Added parameter
    this.hintText = 'Select an option', // Default hint text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0), // Match text field radius
        color: dropdownColor ?? Colors.grey.shade200, // Use dropdownColor or default to grey
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        hint: Text(hintText), // Use hintText parameter
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
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
