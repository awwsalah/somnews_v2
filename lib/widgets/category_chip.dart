import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Chip(
          label: Text(label),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: isSelected ? null : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey[300]!,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          // The gradient is handled by the background decoration
          // We apply it here for the selected state
          color: isSelected
              ? MaterialStateProperty.all<Color>(Colors.transparent)
              : null,
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }
}

// A wrapper to apply a gradient to the Chip
class GradientChip extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const GradientChip({Key? key, required this.child, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
