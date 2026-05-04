import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

import '../../../../../core/utls/functions/is_arabic.dart';
import '../../../../../generated/l10n.dart';

/// A comprehensive card widget that displays a single Quranic Ayah with its metadata and actions.
///
/// **Key Features:**
/// - Displays Othmanic text using high-quality Hafs font.
/// - Integrated Translation and Tafsir viewer with horizontal swipe support.
/// - Dynamic highlighting for playback tracking.
/// - Action buttons for Copying, Bookmarking, Playing audio, and viewing Ayah info.
class AyahCard extends StatefulWidget {
  final int verseNumber;
  final String othmanicText;

  /// Optional English translation text.
  final String? englishTranslation;

  /// Optional English Tafsir text.
  final String? englishTafsir;

  /// Whether the card should be highlighted (e.g., during audio playback).
  final bool isHighlighted;
  final Color highlightColor;

  /// General playing state of the audio player.
  final bool isPlaying;

  /// Specifically indicates if this Ayah is currently the active one in the player.
  final bool isThisAyahSelected;

  final bool isBookmarked;
  final bool hasNote;

  // Action callbacks
  final VoidCallback onInfo;
  final VoidCallback onBookmark;
  final VoidCallback onCopy;
  final VoidCallback onTogglePlay;
  final VoidCallback? onViewNote;

  const AyahCard({
    super.key,
    required this.verseNumber,
    required this.othmanicText,
    this.englishTranslation,
    this.englishTafsir,
    required this.isHighlighted,
    required this.highlightColor,
    required this.isPlaying,
    required this.isThisAyahSelected,
    required this.isBookmarked,
    required this.hasNote,
    required this.onInfo,
    required this.onBookmark,
    required this.onCopy,
    required this.onTogglePlay,
    this.onViewNote,
  });

  @override
  State<AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<AyahCard> {
  /// Internal index to toggle between Translation (0) and Tafsir (1).
  int _currentEnglishIndex = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bool isThisAyahPlaying = widget.isThisAyahSelected && widget.isPlaying;

    // Check if there's any English content to show (Translation or Tafsir)
    final bool hasEnglishContent = LanguageHelper.isEnglish() &&
        ((widget.englishTranslation?.isNotEmpty ?? false) || (widget.englishTafsir?.isNotEmpty ?? false));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isHighlighted
            ? widget.highlightColor.withOpacity(0.2)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isHighlighted ? widget.highlightColor : primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ==========================================
          // Header Section: Ayah Number & Action Icons
          // ==========================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ayah Number Indicator
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${s.ayah} ${widget.verseNumber}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12),
                  ),
                ),

                // Toolbar Actions
                Row(
                  children: [
                    if (widget.hasNote)
                      IconButton(
                        icon: const Icon(Icons.edit_note, size: 20),
                        color: primaryColor,
                        tooltip: s.view_note,
                        onPressed: widget.onViewNote,
                      ),
                    IconButton(
                        icon: const Icon(Icons.info_outline, size: 20),
                        color: primaryColor,
                        tooltip: s.ayah_info,
                        onPressed: widget.onInfo
                    ),
                    IconButton(
                        icon: Icon(
                            widget.isBookmarked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                            size: 20
                        ),
                        color: widget.isBookmarked ? Colors.redAccent : primaryColor,
                        tooltip: widget.isBookmarked ? s.delete_bookmark : s.save_bookmark,
                        onPressed: widget.onBookmark
                    ),
                    IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 20),
                        color: primaryColor,
                        tooltip: s.copy_ayah,
                        onPressed: widget.onCopy
                    ),
                    IconButton(
                      icon: Icon(
                          isThisAyahPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                          color: primaryColor,
                          size: 24
                      ),
                      tooltip: isThisAyahPlaying ? s.pause : s.play,
                      onPressed: widget.onTogglePlay,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ==========================================
          // Content Section: Quranic Text & English Tab
          // ==========================================
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Othmanic Text (RTL)
                Text(
                  widget.othmanicText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: QuranTextStyles.hafsStyle(
                    fontSize: 26,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    height: 1.8,
                  ),
                ),

                // 2. Interactive Translation/Tafsir Section
                if (hasEnglishContent) ...[
                  const SizedBox(height: 16),
                  Divider(color: primaryColor.withOpacity(0.1), thickness: 1),
                  const SizedBox(height: 8),

                  // Tab Title and Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currentEnglishIndex == 0 ? "Translation" : "Tafsir",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor.withOpacity(0.7),
                        ),
                      ),
                      // Dot indicators for swipe feedback
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 3,
                              backgroundColor: _currentEnglishIndex == 0 ? primaryColor : Colors.grey.withOpacity(0.3)
                          ),
                          const SizedBox(width: 4),
                          CircleAvatar(
                              radius: 3,
                              backgroundColor: _currentEnglishIndex == 1 ? primaryColor : Colors.grey.withOpacity(0.3)
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Swipeable Content Area
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragEnd: (details) {
                      // Logic for switching tabs via swiping
                      if (details.primaryVelocity! > 0) {
                        // Swiped Right -> Go to Translation
                        if (_currentEnglishIndex != 0) {
                          setState(() => _currentEnglishIndex = 0);
                        }
                      } else if (details.primaryVelocity! < 0) {
                        // Swiped Left -> Go to Tafsir
                        if (_currentEnglishIndex != 1 && widget.englishTafsir != null) {
                          setState(() => _currentEnglishIndex = 1);
                        }
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        _currentEnglishIndex == 0
                            ? (widget.englishTranslation ?? "Translation not available")
                            : (widget.englishTafsir ?? "Tafsir not available"),
                        key: ValueKey<int>(_currentEnglishIndex),
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}