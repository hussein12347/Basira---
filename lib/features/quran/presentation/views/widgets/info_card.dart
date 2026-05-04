import 'package:flutter/material.dart';

/// A compact information card widget designed to display a single metric or attribute.
///
/// It consists of an [icon], a small [title], and a prominent [value].
/// This widget is highly effective when used in a Row or Grid to display
/// metadata such as Page numbers, Juz, or Revelation types.
class InfoCard extends StatelessWidget {
  /// The descriptive label for the information (e.g., "Page", "Juz").
  final String title;

  /// The actual data or value to display (e.g., "Page 1", "Makkah").
  final String value;

  /// The visual icon representing the category of information.
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        // Subtle border to define the card's boundary within a light/dark theme
        border: Border.all(color: primaryColor.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              icon,
              color: primaryColor.withOpacity(0.8),
              size: 24
          ),
          const SizedBox(height: 10),

          // Display the title in a subtle grey color for visual hierarchy
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Display the value prominently using the theme's primary color
          Text(
            value,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryColor
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}