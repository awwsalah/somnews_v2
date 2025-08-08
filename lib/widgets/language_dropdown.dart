import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final String currentLanguage;
  final Function(String?) onChanged;

  const LanguageDropdown({
    Key? key,
    required this.currentLanguage,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentLanguage,
      icon: const Icon(Icons.language, color: Colors.white),
      dropdownColor: const Color(0xFF2196F3), // Match the gradient blue
      underline: const SizedBox(), // Removes the default underline
      onChanged: onChanged,
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text('EN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        DropdownMenuItem(
          value: 'so',
          child: Text('SO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
