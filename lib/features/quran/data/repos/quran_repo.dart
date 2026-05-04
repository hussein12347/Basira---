
import '../models/book_mark_model.dart';

abstract class QuranRepo {
  String getTafsirText(int surah, int verse) ;
  String getEnTafsir({
    required int surahNumber,
    required int ayahNumber,
  }) ;
  String getEnTranslation({
    required int surahNumber,
    required int ayahNumber,
  });
  Future<bool> addBookmark(BookMarkModel bookmark);

  Future<bool> deleteBookmark(int id);
  Future<List<Map<String, dynamic>>> searchInTranslationAndTafsir(String query);
  Future<List<BookMarkModel>> getAllBookmarks();
}