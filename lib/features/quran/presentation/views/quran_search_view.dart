import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

import '../../../../const/constant.dart';
import '../../../../core/utls/styles/app_styles.dart';
import '../../../../core/utls/functions/is_arabic.dart';
import '../../../../generated/l10n.dart';
import '../../data/repos/quran_repo.dart';
import '../../data/repos/quran_repo_impl.dart';

/// A robust search interface for the Quran, supporting multi-language queries.
///
/// **Key Features:**
/// - **Dual-Source Search:** Queries the original Arabic text and English translations/tafsir.
/// - **Debounced Input:** Prevents UI lag by waiting 500ms after the user stops typing before searching.
/// - **Unified Results:** Displays findings from all sources in a consistent card format.
/// - **Localization:** Fully supports RTL (Arabic) and LTR (English) layouts dynamically.
class QuranSearchView extends StatefulWidget {
  const QuranSearchView({super.key});

  @override
  State<QuranSearchView> createState() => _QuranSearchViewState();
}

class _QuranSearchViewState extends State<QuranSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// Timer used for debouncing search input to optimize performance.
  Timer? _debounce;

  /// Holds the combined results from both Arabic and English sources.
  List<Map<String, dynamic>> _searchResults = [];
  int _searchOccurrences = 0;
  bool _isSearching = false;
  String _currentQuery = '';

  final QuranRepo _quranRepo = QuranRepoImpl();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Triggers the debounced search logic whenever the input changes.
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _searchOccurrences = 0;
        _currentQuery = '';
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  /// Executes the search across all data sources.
  ///
  /// It first cleans the query for Arabic searching (normalization),
  /// then optionally searches English sources if no Arabic characters are detected.
  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _currentQuery = query;
    });

    // 1. Arabic Text Search
    // The normalise() function removes diacritics for better matching.
    String cleanedQuery = normalise(query);
    Map arabicResultsData = searchWords(cleanedQuery);

    List<Map<String, dynamic>> unifiedResults = [];

    // Transform Arabic results into the unified schema
    if (arabicResultsData['occurences'] > 0) {
      List<Map> quranRes = List<Map>.from(arabicResultsData['result']);
      for (var item in quranRes) {
        unifiedResults.add({
          'sora': item['sora'],
          'aya_no': item['aya_no'],
          'type': 'quran',
          'text': getVerse(item['sora'], item['aya_no'], verseEndSymbol: true),
        });
      }
    }

    // 2. English Translation & Tafsir Search
    // Optimization: Only search English data if the query isn't strictly Arabic.
    if (!LanguageHelper.isArabicText(query)) {
      List<Map<String, dynamic>> englishResults =
      await _quranRepo.searchInTranslationAndTafsir(query);
      unifiedResults.addAll(englishResults);
    }

    setState(() {
      _searchResults = unifiedResults;
      _searchOccurrences = unifiedResults.length;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.searchInQuran,
          style: AppStyles.semiBold24(context).copyWith(color: primaryColor),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // --- Search Input Bar ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                autofocus: true,
                onChanged: _onSearchChanged,
                style: AppStyles.regular16(context),
                decoration: InputDecoration(
                  hintText: s.searchHintText,
                  hintStyle: AppStyles.regular14(context).copyWith(color: Colors.grey),
                  prefixIcon: Icon(CupertinoIcons.search, color: primaryColor),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                      _focusNode.requestFocus();
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
          ),

          // --- Result Display Area ---
          Expanded(
            child: _buildBodyContent(primaryColor, s),
          ),
        ],
      ),
    );
  }

  /// Builds a stylized card for a single search result.
  ///
  /// Dynamically adjusts typography and text direction based on the [resultType].
  Widget _buildResultCard({
    required Color primaryColor,
    required String surahName,
    required int surahNum,
    required int verseNum,
    required int pageNum,
    required String verseText,
    required String resultType,
    required S s,
  }) {
    bool isQuran = resultType == 'quran';
    TextDirection textDir = isQuran ? TextDirection.rtl : TextDirection.ltr;
    TextAlign textAlign = isQuran ? TextAlign.right : TextAlign.left;
    String fontFamily = isQuran ? 'hafs' : 'sans-serif';

    // Badge Label for source identification
    String badgeText = '';
    if (resultType == 'quran') badgeText = 'قرآن - Quran';
    if (resultType == 'translation') badgeText = 'ترجمة - Translation';
    if (resultType == 'tafsir') badgeText = 'تفسير - Tafsir';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push(
            kQuranPageViewRoute,
            extra: {
              "surahNumber": surahNum,
              "pageNumber": pageNum,
              "verseNumber": verseNum,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Header: Surah Info & Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.book, size: 16, color: primaryColor),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${s.surah} $surahName',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${s.verse} $verseNum)',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Card Body: The Result Text
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  verseText.replaceAll('\n', ' '),
                  textAlign: textAlign,
                  textDirection: textDir,
                  style: TextStyle(
                    fontSize: isQuran ? 22 : 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    height: 1.8,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Manages the state of the main content area (Loading, Empty, No Results, or List).
  Widget _buildBodyContent(Color primaryColor, S s) {
    if (_isSearching) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    if (_currentQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.book, size: 80, color: primaryColor.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(
              s.searchEmptyText,
              style: AppStyles.regular16(context).copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_searchOccurrences == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.search, size: 80, color: Colors.red.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              '${s.noResultsFor} "$_currentQuery"',
              style: AppStyles.regular16(context).copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Summary Header for results found
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${s.foundResults} $_searchOccurrences ${s.resultsCount}',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Results List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: _searchResults.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              int surahNum = result['sora'];
              int verseNum = result['aya_no'];
              String type = result['type'];
              String resultText = result['text'];

              String surahName = LanguageHelper.isArabic()
                  ? getSurahNameArabic(surahNum)
                  : getSurahName(surahNum);

              int pageNum = getPageNumber(surahNum, verseNum);

              return _buildResultCard(
                primaryColor: primaryColor,
                surahName: surahName,
                surahNum: surahNum,
                verseNum: verseNum,
                pageNum: pageNum,
                verseText: resultText,
                resultType: type,
                s: s,
              );
            },
          ),
        ),
      ],
    );
  }
}