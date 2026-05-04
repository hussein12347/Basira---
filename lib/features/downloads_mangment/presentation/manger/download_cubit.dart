import 'dart:developer';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:meta/meta.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

import '../../../quran/presentation/views/widgets/AudioUtils.dart';

part 'download_state.dart';

/// A [Cubit] responsible for managing the downloading and deleting of Quranic audio files.
///
/// It utilizes `background_downloader` for robust file fetching and `dio`
/// for checking file sizes prior to downloading to avoid redundant downloads.
class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());

  final Dio _dio = Dio();

  /// Internal helper to download a single file.
  ///
  /// [url] The remote URL of the file.
  /// [fileName] The intended name of the file on the local device.
  /// [filePath] The absolute local path where the file should be saved.
  /// [onProgress] Callback to report the download progress (0.0 to 1.0).
  ///
  /// **Optimization:** It performs a `HEAD` request using Dio to check the server
  /// file size. If a local file exists with the exact same size, the download
  /// is skipped to save bandwidth and time.
  Future<bool> _internalDownloadFile(
      String url, String fileName, String filePath, Function(double) onProgress) async {
    try {
      final file = File(filePath);

      // Perform a HEAD request to get the content length without downloading the body
      final headResponse = await _dio.head(url);
      final serverLength =
          int.tryParse(headResponse.headers.value('content-length') ?? '') ?? 0;

      // Check if the file already exists and is fully downloaded
      if (await file.exists()) {
        final localLength = await file.length();
        if (localLength == serverLength) {
          log("File exists, skipping: $filePath");
          onProgress(1.0); // Immediately report 100% completion
          return true;
        }
      }

      // Define the background download task
      final task = DownloadTask(
        url: url,
        filename: fileName,
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress,
        allowPause: true,
      );

      // Execute the download
      final result = await FileDownloader().download(
        task,
        onProgress: (progress) {
          if (progress >= 0.0) {
            onProgress(progress);
          }
        },
      );

      return result.status == TaskStatus.complete;
    } catch (e) {
      log("Failed to download $url: $e");
      return false;
    }
  }

  /// Internal helper to delete a single local file.
  ///
  /// Returns `true` if the file was deleted successfully or if it didn't exist in the first place.
  Future<bool> _internalDeleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        log("Deleted: $filePath");
        return true;
      } else {
        log("File not found, skipping delete: $filePath");
        return true;
      }
    } catch (e) {
      log("Failed to delete $filePath: $e");
      return false;
    }
  }

  /// Downloads the audio files for a specific range of Surahs, verse by verse.
  ///
  /// [audio] The audio model containing the reciter's metadata and server format.
  /// [startIndex] The 0-based index of the starting Surah (e.g., 0 for Al-Fatihah).
  /// [endIndex] The 0-based index of the ending Surah.
  ///
  /// Emits [DownloadLoading] continuously with the overall batch progress,
  /// and [DownloadSuccess] when the entire batch is completed.
  Future<void> downloadSurahRangeForVerse(
      AudioModel audio,
      int startIndex,
      int endIndex,
      ) async {
    emit(DownloadLoading(0.0));
    try {
      // Request notification permissions for the background downloader
      var permissionStatus = await FileDownloader().permissions.status(PermissionType.notifications);
      if (permissionStatus != PermissionStatus.granted) {
        await FileDownloader().permissions.request(PermissionType.notifications);
      }

      final dir = await getApplicationDocumentsDirectory();

      // Calculate the total number of ayahs in the requested range to calculate overall progress
      int totalAyahs = 0;
      for (int i = startIndex; i <= endIndex; i++) {
        totalAyahs += getVerseCount(i + 1);
      }
      if (totalAyahs == 0) {
        emit(DownloadInitial());
        return;
      }

      int ayahsProcessed = 0;

      // Loop through each Surah in the range
      for (int i = startIndex; i <= endIndex; i++) {
        int surahNumber = i + 1; // 1-based Surah number
        int ayahCount = getVerseCount(surahNumber);

        // Loop through each Verse in the current Surah
        for (int verse = 1; verse <= ayahCount; verse++) {
          final url = AudioUtils.getAudioUrl(audio, surahNumber, verse);
          if (url == null) {
            ayahsProcessed++;
            continue;
          }

          // Format: reciterId_surahNumber_verseNumber.mp3
          final fileName = "${audio.id}_${surahNumber}_$verse.mp3";
          final filePath = '${dir.path}/$fileName';

          final success = await _internalDownloadFile(url, fileName, filePath,
                  (singleFileProgress) {
                // Calculate the overall progress including the fractional progress of the current file
                double totalProgress =
                    (ayahsProcessed + singleFileProgress) / totalAyahs;
                emit(DownloadLoading(totalProgress));
              });

          if (!success) {
            log("Failed on $fileName, continuing...");
          }

          ayahsProcessed++;
          // Update progress after the file is completely processed
          emit(DownloadLoading(ayahsProcessed / totalAyahs));
        }
      }

      emit(DownloadSuccess('Batch download complete'));
    } catch (e) {
      log(e.toString());
      emit(DownloadError(e.toString()));
    }
  }

  /// Deletes the audio files for a specific range of Surahs, verse by verse.
  ///
  /// [audio] The audio model used to identify the file naming convention.
  /// [startIndex] The 0-based index of the starting Surah.
  /// [endIndex] The 0-based index of the ending Surah.
  ///
  /// Emits [DownloadLoading] continuously with the overall deletion progress,
  /// and [DeleteSuccess] when the entire batch is processed.
  Future<void> deleteSurahRangeForVerse(
      AudioModel audio,
      int startIndex,
      int endIndex,
      ) async {
    emit(DownloadLoading(0.0));
    try {
      final dir = await getApplicationDocumentsDirectory();

      // Calculate the total number of ayahs in the requested range to calculate overall progress
      int totalAyahs = 0;
      for (int i = startIndex; i <= endIndex; i++) {
        totalAyahs += getVerseCount(i + 1);
      }
      if (totalAyahs == 0) {
        emit(DownloadInitial());
        return;
      }

      int ayahsProcessed = 0;

      // Loop through each Surah in the range
      for (int i = startIndex; i <= endIndex; i++) {
        int surahNumber = i + 1; // 1-based Surah number
        int ayahCount = getVerseCount(surahNumber);

        // Loop through each Verse in the current Surah
        for (int verse = 1; verse <= ayahCount; verse++) {
          final fileName = "${audio.id}_${surahNumber}_$verse.mp3";
          final filePath = '${dir.path}/$fileName';

          await _internalDeleteFile(filePath);

          ayahsProcessed++;
          emit(DownloadLoading(ayahsProcessed / totalAyahs));
        }
      }

      emit(DeleteSuccess());
    } catch (e) {
      log(e.toString());
      emit(DownloadError(e.toString()));
    }
  }
}