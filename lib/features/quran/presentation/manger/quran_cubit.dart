import 'package:bloc/bloc.dart';
import 'package:elda3ia_tour/features/quran/data/models/book_mark_model.dart';
import 'package:elda3ia_tour/features/quran/data/repos/quran_repo.dart';
import 'package:meta/meta.dart';

import '../../../../core/services/local_storage_helper.dart';

part 'quran_state.dart';

/// The central controller for the Quran reading experience.
///
/// It manages the user's reading history (Last Read), handles bookmark
/// operations (Fetch, Add, Delete), and toggles between different
/// display modes (Mushaf vs. Verse-by-Verse).
class QuranCubit extends Cubit<QuranState> {
  final QuranRepo repo;

  QuranCubit({required this.repo}) : super(QuranInitial());

  // Cached values for quick access in the UI
  int? lastPage;
  int? lastSurah;
  int? lastAyah;

  /// Determines the UI layout (Traditional Mushaf view vs. List view).
  bool isMushafMode = true;

  /// A local cache of the user's bookmarks to avoid redundant DB calls.
  List<BookMarkModel> bookmarks = [];

  /// Fetches all bookmarks from the repository and refreshes the cache.
  Future<void> fetchBookmarks() async {
    bookmarks = await repo.getAllBookmarks();
    emit(QuranInitial());
  }

  /// Deletes a bookmark by its unique ID and updates the local cache.
  Future<void> deleteBookmark(int id) async {
    await repo.deleteBookmark(id);
    bookmarks.removeWhere((e) => e.id == id);
    emit(QuranInitial());
  }

  /// Adds a new bookmark and performs a full refresh of the list to ensure sync.
  Future<void> addBookmark(BookMarkModel bookmark) async {
    await repo.addBookmark(bookmark);
    // Clearing and re-fetching ensures the UI stays consistent with the DB state.
    bookmarks.clear();
    bookmarks = await repo.getAllBookmarks();
    emit(QuranInitial());
  }

  /// Initializes the Cubit by loading saved settings and history from local storage.
  Future<void> init() async {
    lastPage = await LocalStorageHelper.getLastPage();
    lastSurah = await LocalStorageHelper.getLastSurah();
    lastAyah = await LocalStorageHelper.getLastAyah();

    isMushafMode = await LocalStorageHelper.getIsMushafMode();

    bookmarks = await repo.getAllBookmarks();

    emit(QuranInitial());
  }

  /// Updates the "Last Read" session both in memory and in persistent local storage.
  ///
  /// [page] and [surah] are required, while [verse] is optional depending
  /// on the display mode used during the reading session.
  Future<void> updateLastRead(int page, int surah, {int? verse}) async {
    await LocalStorageHelper.saveLastPage(page);
    await LocalStorageHelper.saveLastSurah(surah);

    if (verse != null) {
      await LocalStorageHelper.saveLastAyah(verse);
      lastAyah = verse;
    }

    lastPage = page;
    lastSurah = surah;

    // Emit initial to notify listeners that the state/variables have changed.
    emit(QuranInitial());
  }

  /// Toggles between Mushaf mode and List mode, saving the preference locally.
  Future<void> toggleDisplayMode(bool isMushaf) async {
    isMushafMode = isMushaf;
    await LocalStorageHelper.saveIsMushafMode(isMushaf);
    emit(QuranInitial());
  }
}