import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/models/book_mark_model.dart';
import '../../manger/quran_cubit.dart';

/// A modal bottom sheet that allows users to save a specific verse as a bookmark.
///
/// Users can add an optional text note and select a custom identification color
/// from a predefined palette. The sheet handles keyboard visibility to prevent
/// UI obstruction during text input.
class AddBookmarkSheet extends StatefulWidget {
  /// The 1-based index of the Surah containing the verse.
  final int surahNumber;

  /// The number of the verse to be bookmarked.
  final int verseNumber;

  const AddBookmarkSheet({super.key, required this.surahNumber, required this.verseNumber});

  @override
  State<AddBookmarkSheet> createState() => _AddBookmarkSheetState();
}

class _AddBookmarkSheetState extends State<AddBookmarkSheet> {
  final TextEditingController _noteController = TextEditingController();

  /// The integer value of the currently selected color (defaults to redAccent).
  int _selectedColorValue = Colors.redAccent.value;

  /// A wide palette of colors available for the user to categorize their bookmarks.
  final List<Color> _colors = [
    Colors.red, Colors.redAccent, Colors.pink, Colors.pinkAccent,
    Colors.orange, Colors.orangeAccent, Colors.deepOrange, Colors.amber,
    Colors.yellow, Colors.lime, Colors.green, Colors.greenAccent,
    Colors.teal, Colors.cyan, Colors.lightBlue, Colors.blue,
    Colors.blueAccent, Colors.indigo, Colors.deepPurple, Colors.purple,
    Colors.purpleAccent, Colors.brown, Colors.grey, Colors.blueGrey,
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // Localization initialization
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      // Adjust padding based on the keyboard height to ensure the sheet stays visible
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top drag handle decoration
            Center(
              child: Container(
                width: 50, height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              s.save_bookmark_title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 16),

            // Note input field
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: s.add_note_optional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            Text(
              s.choose_bookmark_color,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Color Picker List
            SizedBox(
              height: 40,
              child: ListView.separated(
                itemCount: _colors.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorValue = color.value),
                    child: CircleAvatar(
                      backgroundColor: color,
                      child: _selectedColorValue == color.value
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Confirm/Save Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final bookmark = BookMarkModel(
                    surahNumber: widget.surahNumber,
                    verseNumber: widget.verseNumber,
                    note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                    colorValue: _selectedColorValue,
                  );

                  // Trigger the save action via QuranCubit and close the sheet
                  context.read<QuranCubit>().addBookmark(bookmark);
                  Navigator.pop(context);
                },
                child: Text(
                  s.save_bookmark_button,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}