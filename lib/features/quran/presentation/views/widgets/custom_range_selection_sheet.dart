import 'package:elda3ia_tour/core/utls/functions/is_arabic.dart';
import 'package:flutter/material.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

import '../../../../../generated/l10n.dart';

/// A modal sheet that allows users to select a custom range of verses for audio playback.
///
/// It dynamically manages constraints between the 'Start' and 'End' selections:
/// - The end Surah cannot be before the start Surah.
/// - If the Surahs are the same, the end Verse cannot be before the start Verse.
/// - Verse counts are automatically updated based on the selected Surah.
class CustomRangeSelectionSheet extends StatefulWidget {
  /// The initial Surah number to display (1-114).
  final int initialSurah;

  /// The initial Verse number to display.
  final int initialVerse;

  const CustomRangeSelectionSheet({
    super.key,
    required this.initialSurah,
    required this.initialVerse,
  });

  @override
  State<CustomRangeSelectionSheet> createState() => _CustomRangeSelectionSheetState();
}

class _CustomRangeSelectionSheetState extends State<CustomRangeSelectionSheet> {
  late int startSurah;
  late int startVerse;
  late int endSurah;
  late int endVerse;

  @override
  void initState() {
    super.initState();
    startSurah = widget.initialSurah;
    startVerse = widget.initialVerse;
    endSurah = widget.initialSurah;
    endVerse = widget.initialVerse;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // Localization initialization
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visual handle for draggable sheets
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.play_custom_range,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),

          // --- Start Point Selection Section ---
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(s.from_start, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildSurahDropdown(
                  context: context,
                  value: startSurah,
                  minSurah: 1,
                  onChanged: (val) {
                    setState(() {
                      startSurah = val!;
                      startVerse = 1; // Reset verse when Surah changes
                      // Ensure end point is not before start point
                      if (endSurah < startSurah) {
                        endSurah = startSurah;
                        endVerse = 1;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: _buildVerseDropdown(
                  context: context,
                  surah: startSurah,
                  value: startVerse,
                  minVerse: 1,
                  onChanged: (val) {
                    setState(() {
                      startVerse = val!;
                      // Ensure end verse is valid if in the same Surah
                      if (startSurah == endSurah && endVerse < startVerse) {
                        endVerse = startVerse;
                      }
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // --- End Point Selection Section ---
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(s.to_end, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildSurahDropdown(
                  context: context,
                  value: endSurah,
                  minSurah: startSurah, // End Surah cannot precede Start Surah
                  onChanged: (val) {
                    setState(() {
                      endSurah = val!;
                      // Validate verse selection against new Surah constraints
                      if (endSurah == startSurah && endVerse < startVerse) {
                        endVerse = startVerse;
                      } else if (endVerse > getVerseCount(endSurah)) {
                        endVerse = getVerseCount(endSurah);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: _buildVerseDropdown(
                  context: context,
                  surah: endSurah,
                  value: endVerse,
                  minVerse: startSurah == endSurah ? startVerse : 1,
                  onChanged: (val) {
                    setState(() {
                      endVerse = val!;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // --- Execution Button ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Return selected range to the calling screen
                Navigator.pop(context, {
                  'startSurah': startSurah,
                  'startVerse': startVerse,
                  'endSurah': endSurah,
                  'endVerse': endVerse,
                });
              },
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: Text(
                s.start_recitation,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget to construct the Surah selection dropdown.
  Widget _buildSurahDropdown({
    required BuildContext context,
    required int value,
    required int minSurah,
    required void Function(int?) onChanged
  }) {
    List<DropdownMenuItem<int>> items = [];
    for (int i = minSurah; i <= 114; i++) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(
            LanguageHelper.isArabic() ? getSurahNameArabic(i) : getSurahName(i),
            overflow: TextOverflow.ellipsis
        ),
      ));
    }
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10)
      ),
      initialValue: value,
      items: items,
      dropdownColor: Theme.of(context).primaryColor,
      onChanged: onChanged,
    );
  }

  /// Helper widget to construct the Verse selection dropdown based on the chosen Surah.
  Widget _buildVerseDropdown({
    required BuildContext context,
    required int surah,
    required int value,
    required int minVerse,
    required void Function(int?) onChanged
  }) {
    final s = S.of(context);
    int maxVerses = getVerseCount(surah);
    List<DropdownMenuItem<int>> items = [];
    for (int i = minVerse; i <= maxVerses; i++) {
      items.add(DropdownMenuItem(
          value: i,
          child: Text("${s.ayah} $i")
      ));
    }
    // Ensure the current value is within the new range to avoid UI crashes
    int safeValue = (value >= minVerse && value <= maxVerses) ? value : minVerse;

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10)
      ),
      initialValue: safeValue,
      items: items,
      dropdownColor: Theme.of(context).primaryColor,
      onChanged: onChanged,
    );
  }
}