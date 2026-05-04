import 'package:flutter/material.dart';

/// A reusable section widget used to display interpretive text (Tafsir) or translations.
///
/// **Key Features:**
/// - Smart Directionality: Automatically switches between RTL (Arabic) and LTR (English) layouts.
/// - Themed Headers: Displays a title accompanied by a context-relevant icon.
/// - Readability: Uses justified text alignment and customized line height for a better reading experience.
class TafsirSection extends StatelessWidget {
  /// The header text for the section (e.g., "Tafsir Al-Muyassar").
  final String title;

  /// The actual body of text to be displayed.
  final String content;

  /// Determines the text direction and the icon type.
  ///
  /// If `true`, the layout will be Right-to-Left (Arabic).
  /// If `false`, the layout will be Left-to-Right (English).
  final bool isArabic;

  const TafsirSection({
    super.key,
    required this.title,
    required this.content,
    required this.isArabic
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        // --- Section Header (Icon + Title) ---
        Row(
          children: [
            Icon(
                isArabic ? Icons.library_books_outlined : Icons.translate,
                color: primaryColor,
                size: 22
            ),
            const SizedBox(width: 8),
            Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontFamily: 'Cairo'
                )
            ),
          ],
        ),

        const Divider(height: 20),

        // --- Content Container ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12)
          ),
          child: Text(
            content,
            // Uses justify for a professional "book-like" paragraph appearance
            textAlign: TextAlign.justify,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                fontFamily: 'Cairo'
            ),
          ),
        ),

        const SizedBox(height: 25),
      ],
    );
  }
}