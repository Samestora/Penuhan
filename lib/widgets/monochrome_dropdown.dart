import 'package:flutter/material.dart';

/// A reusable, monochrome-styled dropdown button.
class MonochromeDropdown extends StatelessWidget {
  /// The currently selected value for the dropdown.
  final String value;

  /// A map of available items, where the key is the value
  /// and the value is the display text.
  final Map<String, String> items;

  /// A callback function that is triggered when a new item is selected.
  final ValueChanged<String?> onChanged;

  const MonochromeDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.grey.shade900,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(fontFamily: "Unifont", fontSize: 16),
          onChanged: onChanged,
          // Create the list of items from the provided map.
          items: items.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
