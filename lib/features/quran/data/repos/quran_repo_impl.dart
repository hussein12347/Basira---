import 'package:elda3ia_tour/core/utls/data_base/my_sql_database.dart';
import 'package:elda3ia_tour/features/quran/data/repos/quran_repo.dart';

import '../../../../const/constant.dart';
import '../data/ar_tafsir_data.dart';
import '../data/en_tafsir_data.dart';
import '../data/translate.dart';
import '../models/book_mark_model.dart';

/// The implementation of [QuranRepo] that acts as the single source of truth
/// for Quran-related data.
///
/// It handles fetching local static data (Tafsir & Translations) and manages
/// dynamic user data (Bookmarks) via a local SQL database.
class QuranRepoImpl implements QuranRepo {
  final MySqlDataBase _sql = MySqlDataBase();

  /// Fetches the Arabic Tafsir (Al-Muyassar) for a specific Surah and Verse.
  ///
  /// It searches through the pre-loaded [tafsir] list.
  @override
  String getTafsirText(int surah, int verse) {
    try {
      // Searching the list for the matching element.
      // Note: Numbers are converted to Strings because the provided data list uses String values.
      final result = tafsir.firstWhere(
            (element) => element['number'] == surah.toString() && element['aya'] == verse.toString(),
        orElse: () => {'text': 'التفسير غير متوفر حالياً.'},
      );
      return result['text']!;
    } catch (e) {
      return 'حدث خطأ أثناء تحميل التفسير.';
    }
  }

  /// Fetches the English Tafsir for a specific Surah and Verse.
  ///
  /// Utilizes the [enTafsir] 2D array where the first index is (Surah - 1)
  /// and the second is (Ayah - 1).
  @override
  String getEnTafsir({
    required int surahNumber,
    required int ayahNumber,
  }) {
    try {
      return enTafsir[surahNumber - 1][ayahNumber - 1];
    } catch (e) {
      return "Tafsir not found";
    }
  }

  /// Fetches the English Translation for a specific Surah and Verse.
  ///
  /// Utilizes the [translateQuran] map where keys are Surah numbers as strings.
  @override
  String getEnTranslation({
    required int surahNumber,
    required int ayahNumber,
  }) {
    try {
      final surah = translateQuran[surahNumber.toString()];
      return surah[ayahNumber - 1]["text"];
    } catch (e) {
      return "Translation not found";
    }
  }

  // ==========================================
  // Bookmarks Management (Local Database)
  // ==========================================

  /// Inserts a new [BookMarkModel] into the local SQL database.
  @override
  Future<bool> addBookmark(BookMarkModel bookmark) async {
    try {
      return await _sql.insert(
        tableName: kBookmarksTableName,
        values: bookmark.toMap(),
      );
    } catch (e) {
      print("Error adding bookmark: $e");
      return false;
    }
  }

  /// Deletes a specific bookmark from the database using its unique [id].
  @override
  Future<bool> deleteBookmark(int id) async {
    try {
      return await _sql.delete(
        tableName: kBookmarksTableName,
        id: id,
        ColumnIDName: 'id',
      );
    } catch (e) {
      print("Error deleting bookmark: $e");
      return false;
    }
  }

  /// Retrieves all saved bookmarks from the database, ordered by creation date (newest first).
  @override
  Future<List<BookMarkModel>> getAllBookmarks() async {
    try {
      final List<Map<String, dynamic>> result = await _sql.selectUsingQuery(
        query: 'SELECT * FROM $kBookmarksTableName ORDER BY $kCreatedAtColumn DESC',
      );

      return result.map((map) => BookMarkModel.fromMap(map)).toList();
    } catch (e) {
      print("Error fetching bookmarks: $e");
      return [];
    }
  }

  // ==========================================
  // Search Functionality
  // ==========================================

  /// Searches for a specific [query] string within the English Translation data.
  ///
  /// Returns a list of maps containing the Surah number, Ayah number,
  /// the type of result ('translation'), and the matching text.
  @override
  Future<List<Map<String, dynamic>>> searchInTranslationAndTafsir(String query) async {
    List<Map<String, dynamic>> results = [];
    String lowerQuery = query.toLowerCase();

    if (lowerQuery.trim().isEmpty) return results;

    // 1. Search in English Translation
    try {
      translateQuran.forEach((surahKey, ayahs) {
        int surahNum = int.tryParse(surahKey) ?? 0;
        // 'ayahs' is a List of Maps based on the translation file structure
        for (int i = 0; i < ayahs.length; i++) {
          String text = ayahs[i]['text'] ?? '';
          if (text.toLowerCase().contains(lowerQuery)) {
            results.add({
              'sora': surahNum,
              'aya_no': i + 1,
              'type': 'translation', // 💡 Identify the source type for the UI
              'text': text,
            });
          }
        }
      });
    } catch (e) {
      print("Error searching translation: $e");
    }

    // // 2. Search in English Tafsir (Currently Commented Out)
    // try {
    //   for (int i = 0; i < enTafsir.length; i++) {
    //     for (int j = 0; j < enTafsir[i].length; j++) {
    //       String text = enTafsir[i][j];
    //       if (text.toLowerCase().contains(lowerQuery)) {
    //         results.add({
    //           'sora': i + 1,
    //           'aya_no': j + 1,
    //           'type': 'tafsir', // 💡 Identify the source type for the UI
    //           'text': text,
    //         });
    //       }
    //     }
    //   }
    // } catch (e) {
    //   print("Error searching tafsir: $e");
    // }

    return results;
  }
}