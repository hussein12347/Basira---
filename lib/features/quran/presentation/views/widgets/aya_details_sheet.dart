import 'package:elda3ia_tour/features/quran/presentation/views/widgets/tafsir_section.dart';
import 'package:flutter/material.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/repos/quran_repo_impl.dart';
import 'info_card.dart';

/// A draggable bottom sheet that displays comprehensive details for a specific Ayah.
///
/// **Contents include:**
/// - Metadata cards (Page, Juz, Revelation place, and Quarter).
/// - Arabic Tafsir (Al-Muyassar).
/// - English Tafsir.
/// - English Translation.
///
/// It utilizes a [DraggableScrollableSheet] to allow the user to expand or
/// collapse the view for a comfortable reading experience.
class AyahDetailSheet extends StatelessWidget {
  /// The 1-based index of the Surah.
  final int surahNumber;

  /// The number of the specific Verse within the Surah.
  final int verseNumber;

  /// The repository instance used to fetch Tafsir and translation texts.
  final QuranRepoImpl repo;

  const AyahDetailSheet({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
    required this.repo,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final String revelation = getPlaceOfRevelation(surahNumber);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      snap: true, // Enables smooth snapping to predefined sizes
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          children: [
            // Standard drag handle for UI feedback
            _buildDragHandle(),
            const SizedBox(height: 20),

            // Header: Surah Name and Ayah Number
            Text(
              '${s.surah} ${getSurahNameArabic(surahNumber)} - ${s.ayah} $verseNumber',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Cairo'
              ),
            ),
            const SizedBox(height: 20),

            // Scrollable Content: Info cards and text sections
            Expanded(
              child: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  // --- 1. Quick Info Cards Row ---
                  Row(
                    children: [
                      Expanded(child: InfoCard(title: s.page, value: '${getPageNumber(surahNumber, verseNumber)}', icon: Icons.find_in_page_outlined)),
                      const SizedBox(width: 8),
                      Expanded(child: InfoCard(title: s.juz, value: '${getJuzNumber(surahNumber, verseNumber)}', icon: Icons.pie_chart_outline)),
                      const SizedBox(width: 8),
                      // Localization for Revelation place (Makkah/Madinah)
                      Expanded(child: InfoCard(title: s.revelation, value: revelation == 'Makkah' ? s.revelation_makki : s.revelation_madani, icon: Icons.location_on_outlined)),
                      const SizedBox(width: 8),
                      Expanded(child: InfoCard(title: s.quarter, value: '${getQuarterNumber(surahNumber, verseNumber)}', icon: Icons.donut_large_outlined)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- 2. Detailed Text Sections ---
                  // Arabic Tafsir Al-Muyassar
                  TafsirSection(title: s.tafsir_moyser, content: repo.getTafsirText(surahNumber, verseNumber), isArabic: true),

                  // English Tafsir
                  TafsirSection(title: s.tafsir_english, content: repo.getEnTafsir(surahNumber: surahNumber, ayahNumber: verseNumber), isArabic: false),

                  // English Translation
                  TafsirSection(title: s.english_translation, content: repo.getEnTranslation(surahNumber: surahNumber, ayahNumber: verseNumber), isArabic: false),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the small decorative handle at the top of the sheet to indicate
  /// it can be dragged.
  Widget _buildDragHandle() {
    return Container(
      width: 50, height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}