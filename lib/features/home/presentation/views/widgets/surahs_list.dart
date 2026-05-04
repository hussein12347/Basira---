import 'package:elda3ia_tour/features/home/presentation/views/widgets/surah_title.dart';
import 'package:flutter/material.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
import '../../../../../generated/l10n.dart';

/// A simple data model representing a Quranic Surah for the search list.
///
/// Creating a localized model helps optimize the search functionality
/// by caching the Surah names instead of repeatedly querying the package.
class SurahModel {
  final int id;
  final String nameAr;
  final String nameEn;

  SurahModel({
    required this.id,
    required this.nameAr,
    required this.nameEn
  });
}

/// A searchable list of all 114 Surahs of the Quran.
///
/// This widget optimizes performance by generating the Surah data only once
/// during initialization. It features a responsive search bar that filters
/// Surahs by their Arabic name, English name, or Surah number.
class SurahsList extends StatefulWidget {
  const SurahsList({super.key});

  @override
  State<SurahsList> createState() => _SurahsListState();
}

class _SurahsListState extends State<SurahsList> {
  final TextEditingController _searchController = TextEditingController();

  /// The complete list of 114 Surahs, populated once on startup.
  final List<SurahModel> _allSurahs = [];

  /// The actively displayed list of Surahs, filtered by the search query.
  List<SurahModel> _filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    // Populate the list of all 114 Surahs once to optimize search performance
    for (int i = 1; i <= 114; i++) {
      _allSurahs.add(SurahModel(
        id: i,
        nameAr: getSurahNameArabic(i),
        nameEn: getSurahName(i),
      ));
    }
    _filteredSurahs = List.from(_allSurahs);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filters the Surah list based on the user's input.
  ///
  /// It supports searching by Arabic name, English name, and Surah number
  /// (handling both standard and Arabic numeral inputs).
  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = List.from(_allSurahs);
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          return surah.nameAr.contains(query) ||
              surah.nameEn.toLowerCase().contains(query) ||
              surah.id.toString().contains(query) ||
              _toArabicNumbers(surah.id).contains(query);
        }).toList();
      }
    });
  }

  /// Utility to convert standard numbers into Arabic numerals.
  /// Ensures users using Arabic keyboards can search by number seamlessly.
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1)
                ),
              ),
            ),
          ),
        ),

        // ==========================================
        // Surah List Section
        // ==========================================
        Expanded(
          child: _filteredSurahs.isEmpty
              ? Center(child: Text(S.of(context).no_results_found))
              : ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            // Adds an extra item to act as a spacer for the BottomNavigationBar clearance
            itemCount: _filteredSurahs.length + 1,
            itemBuilder: (context, index) {
              if (index >= _filteredSurahs.length) {
                return const SizedBox(height: kBottomNavigationBarHeight);
              }
              return SurahListTile(
                surah: _filteredSurahs[index].id,
                animationIndex: index,
              );
            },
          ),
        ),
      ],
    );
  }
}