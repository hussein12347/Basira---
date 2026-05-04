import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';

/// A utility class for calculating and tracking audio download progress.
///
/// It provides highly efficient methods to determine how much of the Quran
/// (or a specific Surah) has been downloaded for a given reciter.
class DownloadStatsHelper {
  // Private constructor to prevent instantiation of this utility class.
  DownloadStatsHelper._();

  /// Retrieves a set of all currently downloaded file names from the device.
  ///
  /// **Performance Note:** Fetching all file names once and storing them in a [Set]
  /// provides O(1) lookup performance. This avoids heavy, repetitive disk I/O
  /// operations when iterating over thousands of verses.
  static Future<Set<String>> getAllDownloadedFiles() async {
    final dir = await getApplicationDocumentsDirectory();

    // Fetching all file names in the directory at once to increase performance
    final files = dir.listSync()
        .whereType<File>()
        .map((e) => e.path.split(Platform.pathSeparator).last)
        .toSet();

    return files;
  }

  /// Calculates the overall download progress of the entire Quran for a specific reciter.
  ///
  /// [reciter] The audio model containing the reciter's ID.
  /// [allFiles] A pre-fetched set of downloaded filenames (from [getAllDownloadedFiles]).
  ///
  /// Returns a double between 0.0 (nothing downloaded) and 1.0 (fully downloaded).
  static double getReciterProgress(AudioModel reciter, Set<String> allFiles) {
    int downloadedCount = 0;
    // Total number of verses in the Holy Quran is 6236
    const int totalQuranVerses = 6236;

    for (int surah = 1; surah <= 114; surah++) {
      int ayahsCount = getVerseCount(surah);
      for (int verse = 1; verse <= ayahsCount; verse++) {
        String expectedFileName = "${reciter.id}_${surah}_$verse.mp3";
        if (allFiles.contains(expectedFileName)) {
          downloadedCount++;
        }
      }
    }
    return downloadedCount / totalQuranVerses;
  }

  /// Calculates the download progress of a specific Surah for a given reciter.
  ///
  /// [reciter] The audio model containing the reciter's ID.
  /// [surahNumber] The 1-based index of the Surah (1 to 114).
  /// [allFiles] A pre-fetched set of downloaded filenames.
  ///
  /// Returns a double between 0.0 and 1.0 representing the Surah's download completion.
  static double getSurahProgress(AudioModel reciter, int surahNumber, Set<String> allFiles) {
    int downloadedCount = 0;
    int ayahsCount = getVerseCount(surahNumber);

    for (int verse = 1; verse <= ayahsCount; verse++) {
      String expectedFileName = "${reciter.id}_${surahNumber}_$verse.mp3";
      if (allFiles.contains(expectedFileName)) {
        downloadedCount++;
      }
    }
    return downloadedCount / ayahsCount;
  }
}