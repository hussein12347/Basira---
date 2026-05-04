import 'package:elda3ia_tour/core/utls/functions/is_arabic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
// Direct import for Juzs data
import 'package:qcf_quran_lite/src/data/juzs.dart';

import '../../../../../const/constant.dart';
import '../../../../../const/resource.dart';
import '../../../../../core/utls/functions/convert_to_arabic.dart';
import '../../../../../core/utls/styles/app_styles.dart';
import '../../../../../core/utls/widgets/app_animations.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/models/juz_model.dart';

/// A screen that displays a searchable list of all 30 Juzs (parts) of the Quran.
///
/// It optimizes performance by pre-calculating and caching the Juz data
/// upon initialization, ensuring smooth, real-time search filtering.
class JuzList extends StatefulWidget {
  const JuzList({super.key});

  @override
  State<JuzList> createState() => _JuzListState();
}

class _JuzListState extends State<JuzList> {
  final TextEditingController _searchController = TextEditingController();

  /// A cached list of all 30 Juzs, built once during [initState].
  final List<JuzModel> _allJuzs = [];

  /// The dynamically updated list of Juzs based on the user's search query.
  List<JuzModel> _filteredJuzs = [];

  @override
  void initState() {
    super.initState();
    _prepareJuzData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Prepares the 30 Juzs data once during initialization.
  ///
  /// **Performance Optimization:** By extracting the first Surah and Ayah for
  /// each Juz beforehand, we avoid heavy map lookups during scrolling and searching.
  void _prepareJuzData() {
    for (int i = 0; i < 30; i++) {
      final Map<String, dynamic> juzData = juz[i];
      final Map verses = juzData['verses'];
      final int firstSurah = verses.keys.first;
      final int firstAyah = verses[firstSurah][0];

      _allJuzs.add(JuzModel(
        id: i + 1,
        firstSurah: firstSurah,
        firstAyah: firstAyah,
        pageNumber: getPageNumber(firstSurah, firstAyah),
        surahName: getSurahNameArabic(firstSurah),
      ));
    }
    _filteredJuzs = List.from(_allJuzs);
  }

  /// Filters the [_filteredJuzs] list based on the search query.
  ///
  /// Supports searching by Juz ID (both English and Arabic numerals)
  /// and the Arabic name of the starting Surah.
  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredJuzs = List.from(_allJuzs);
      } else {
        _filteredJuzs = _allJuzs.where((juzItem) {
          return juzItem.id.toString().contains(query) ||
              juzItem.surahName.contains(query) ||
              _toArabicNumbers(juzItem.id).contains(query);
        }).toList();
      }
    });
  }

  /// Helper method to convert English numerals in the search query to Arabic numerals.
  /// This ensures users searching with Arabic keyboards (e.g., '١') get correct results.
  String _toArabicNumbers(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((d) => arabicDigits[int.parse(d)]).join('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==========================================
        // Search Bar Section
        // ==========================================
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: S.of(context).search,
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // ==========================================
        // Juz List Section
        // ==========================================
        Expanded(
          child: _filteredJuzs.isEmpty
              ? Center(child: Text(S.of(context).no_results_found))
              : ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            // Added +1 to inject a bottom spacer for BottomNavigationBar clearance
            itemCount: _filteredJuzs.length + 1,
            itemBuilder: (context, index) {
              if (index >= _filteredJuzs.length) {
                return const SizedBox(height: kBottomNavigationBarHeight);
              }
              return JuzTile(
                juzItem: _filteredJuzs[index],
                animationIndex: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A custom ListTile widget displaying a single Juz's summary.
///
/// It visually presents the Juz number (with a beautifully styled SVG frame),
/// the starting Surah, and the exact page number. Tapping it navigates
/// to the Quran reader exactly at that page.
class JuzTile extends StatelessWidget {
  final JuzModel juzItem;

  /// Used to calculate staggered animation delays for a cascading entrance effect.
  final int animationIndex;

  const JuzTile({
    super.key,
    required this.juzItem,
    required this.animationIndex,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    // Calculate a staggered delay based on the index to create a smooth entry animation
    final delayMS = 50 * (animationIndex % 15);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: _buildJuzNumber(context, juzItem.id, isAr),
          title: Text(
            "${S.of(context).juz} ${isAr ? ConvertToArabic.convertToArabicNumber(juzItem.id) : juzItem.id}",
            style: AppStyles.medium20(context),
          ),
          subtitle: Text(
            "${S.of(context).starts_from_surah} ${LanguageHelper.isArabic() ? juzItem.surahName : getSurahName(juzItem.firstSurah)} - ${S.of(context).page} ${isAr ? ConvertToArabic.convertToArabicNumber(juzItem.pageNumber) : juzItem.pageNumber}",
            style: AppStyles.regular14(context).copyWith(color: Colors.grey),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () {
            // Navigate to the Quran reader page starting directly at this Juz
            context.push(kQuranPageViewRoute, extra: {
              "surahNumber": juzItem.firstSurah,
              "pageNumber": juzItem.pageNumber
            });
          },
        ),
      ),
    ).animateBottomToTop(delay: Duration(milliseconds: delayMS));
  }

  /// Builds a decorative leading widget displaying the Juz number over an SVG background.
  Widget _buildJuzNumber(BuildContext context, int number, bool isAr) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          R.assetsImagesSvgQuranNumberSvg,
          width: 45,
          height: 45,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.secondary,
            BlendMode.srcIn,
          ),
        ),
        Text(
          isAr ? ConvertToArabic.convertToArabicNumber(number) : "$number",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}