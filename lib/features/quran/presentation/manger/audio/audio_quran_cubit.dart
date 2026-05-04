// 💡 File 4: quran_player_cubit.dart

import 'dart:async';
import 'dart:io';
import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

import '../../../../../core/utls/audio_state/audio_cubit.dart';
import '../../../../../core/utls/functions/is_arabic.dart';
import '../../views/widgets/AudioUtils.dart';

import 'audio_quran_state.dart';

/// Manages the playback of Quranic audio (verse by verse).
///
/// It utilizes `just_audio`'s [ConcatenatingAudioSource] to preload sequential
/// verses (Pre-buffering) to ensure gapless playback. It supports multiple playback
/// modes: single verse, a specific range of verses, an entire Surah, or the full Quran.
class QuranPlayerCubit extends Cubit<QuranPlayerState> {
  final AudioCubit audioCubit;
  StreamSubscription? _audioStateSubscription;
  StreamSubscription? _currentIndexSubscription;

  /// Tracks the previous audio state to prevent duplicate 'completed' events.
  ProcessingState _previousProcessingState;

  // Playback mode trackers
  bool _isSequence = false;
  bool _isFullQuran = false;
  bool _isRange = false;

  int? _targetEndSurah;
  int? _targetEndVerse;

  QuranPlayerCubit(this.audioCubit)
      : _previousProcessingState = audioCubit.state.processingState,
        super(QuranPlayerState.initial()) {
    _listenToAudioCubit();
    _listenToCurrentIndex();
  }

  /// Listens to the core audio player state to determine when a playback queue completes.
  void _listenToAudioCubit() {
    _audioStateSubscription = audioCubit.stream.listen((audioState) {
      final newProcessingState = audioState.processingState;

      // Only trigger logic if the state transitions to 'completed'
      if (newProcessingState != ProcessingState.completed) {
        _previousProcessingState = newProcessingState;
        return;
      }

      // Prevent duplicate triggers if the state was already 'completed'
      if (_previousProcessingState == ProcessingState.completed) {
        return;
      }

      _onPlaybackComplete();
      _previousProcessingState = ProcessingState.completed;
    });
  }

  /// Updates the current playing verse in the state based on the playlist index.
  void _listenToCurrentIndex() {
    _currentIndexSubscription = audioCubit.player.currentIndexStream.listen((index) {
      if (index != null && state.startVerse != null) {
        final newVerse = state.startVerse! + index;
        if (newVerse != state.currentVerse) {
          emit(state.copyWith(currentVerse: newVerse));
        }
      }
    });
  }

  /// Toggles repeating the currently playing verse (LoopMode.one).
  void toggleRepeat() {
    final newRepeating = !state.isRepeating;
    audioCubit.player.setLoopMode(newRepeating ? LoopMode.one : LoopMode.off);
    emit(state.copyWith(
      isRepeating: newRepeating,
    ));
  }

  /// Handles the logic when the current playlist finishes playing.
  Future<void> _onPlaybackComplete() async {
    // Mode: Play the entire Quran (transition to the next Surah)
    if (_isSequence && _isFullQuran && state.currentSurahId! < 114) {
      final nextSurah = state.currentSurahId! + 1;
      final nextTotalVerses = getVerseCount(nextSurah);
      await _playVerse(state.currentReciter!, nextSurah, 1, nextTotalVerses);
    }
    // Mode: Play a specific range of verses across multiple Surahs
    else if (_isRange && state.currentSurahId! < _targetEndSurah!) {
      final nextSurah = state.currentSurahId! + 1;
      // If the next Surah is the final target Surah, stop at the target verse.
      // Otherwise, play the entire next Surah.
      int playEndVerse = (nextSurah == _targetEndSurah) ? _targetEndVerse! : getVerseCount(nextSurah);
      await _playVerse(state.currentReciter!, nextSurah, 1, playEndVerse);
    }
    // Mode: Single verse, end of range, or end of Quran reached
    else {
      stop();
    }
  }

  /// Copies an asset image to a temporary directory so it can be used
  /// by `just_audio_background` as media artwork.
  Future<String> copyAssetToTemp(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  /// Internal method to construct a playlist and initiate playback.
  ///
  /// It intelligently mixes local downloaded files and remote URLs in the
  /// same playlist to save bandwidth and ensure gapless playback.
  Future<void> _playVerse(
      AudioModel reciter, int surahId, int verse, int totalVerses) async {
    final List<AudioSource> sources = [];
    final filePath = await copyAssetToTemp('assets/images/png/${reciter.id}.jpg');

    for (int v = verse; v <= totalVerses; v++) {
      // 1. Check if the verse is downloaded locally
      final localPath = await _getLocalAudioPath(surahId, v, reciter);

      if (localPath != null) {
        sources.add(
          AudioSource.file(
            localPath,
            tag: MediaItem(
              id: localPath,
              title: LanguageHelper.isArabic()
                  ? "${getSurahNameArabic(surahId)} - ${getVerse(surahId, v)}"
                  : "${getSurahName(surahId)} - ${getVerse(surahId, v)}",
              artist: LanguageHelper.isArabic() ? reciter.nameAr : reciter.nameEn,
              artUri: Uri.file(filePath),
            ),
          ),
        );
        continue;
      }

      // 2. Fallback to streaming the URL if not downloaded
      final url = AudioUtils.getAudioUrl(reciter, surahId, v);
      if (url == null) {
        debugPrint("No audio URL found for $surahId:$v");
        continue;
      }

      sources.add(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: url,
            title: LanguageHelper.isArabic()
                ? "${getSurahNameArabic(surahId)} - ${getVerse(surahId, v)}"
                : "${getSurahName(surahId)} - ${getVerse(surahId, v)}",
            artist: LanguageHelper.isArabic() ? reciter.nameAr : reciter.nameEn,
            artUri: Uri.file(filePath),
          ),
        ),
      );
    }

    if (sources.isEmpty) {
      stop();
      return;
    }

    final playlist = ConcatenatingAudioSource(children: sources);

    emit(state.copyWith(
      currentReciter: reciter,
      currentSurahId: surahId,
      currentVerse: verse,
      startVerse: verse,
      totalVerses: totalVerses,
    ));

    try {
      await audioCubit.setAndPlayPlaylist(playlist);
      audioCubit.player.setLoopMode(state.isRepeating ? LoopMode.one : LoopMode.off);
    } catch (e) {
      debugPrint('QuranPlayerCubit Exception: $e');
      stop();
    }
  }

  /// Plays a single specific verse.
  Future<void> playSingleVerse(AudioModel reciter, int surahId, int verse) async {
    await audioCubit.stop();
    _isSequence = false;
    _isFullQuran = false;
    _isRange = false;
    // Pass the same verse as start and end to create a 1-item playlist
    await _playVerse(reciter, surahId, verse, verse);
  }

  /// Plays a specific range of verses, spanning across Surahs if necessary.
  Future<void> playVerseRange(
      AudioModel reciter, int startSurahId, int startVerse, int endSurahId, int endVerse) async {
    await audioCubit.stop();
    _isSequence = false;
    _isFullQuran = false;
    _isRange = true;
    _targetEndSurah = endSurahId;
    _targetEndVerse = endVerse;

    // Determine the end verse for the *first* Surah in the range
    int playEndVerse = (startSurahId == endSurahId) ? endVerse : getVerseCount(startSurahId);
    await _playVerse(reciter, startSurahId, startVerse, playEndVerse);
  }

  /// Plays a sequence of verses, typically from a starting point to the end of the Surah.
  Future<void> playVerseSequence(
      AudioModel reciter,
      int surahId,
      int startVerse,
      int totalVerses, {
        bool fullQuran = false,
      }) async {
    await audioCubit.stop();
    _isSequence = true;
    _isFullQuran = fullQuran;
    _isRange = false;
    await _playVerse(reciter, surahId, startVerse, totalVerses);
  }

  /// Swaps the current reciter on the fly while maintaining the playback position
  /// and the active playback mode (Range, Sequence, etc.).
  Future<void> changeReciter(AudioModel newReciter) async {
    if (state.currentVerse == null || state.currentSurahId == null) return;

    final currentPosition = audioCubit.state.position;
    final savedSurah = state.currentSurahId!;
    final savedVerse = state.currentVerse!;
    final savedTotal = state.totalVerses;

    // Save playback modes to resume accurately
    final savedFullQuran = _isFullQuran;
    final savedSequence = _isSequence;
    final savedRange = _isRange;
    final savedTargetSurah = _targetEndSurah;
    final savedTargetVerse = _targetEndVerse;

    await stop();

    // Resume playback based on the previously active mode
    if (savedRange) {
      await playVerseRange(newReciter, savedSurah, savedVerse, savedTargetSurah!, savedTargetVerse!);
    } else if (savedSequence) {
      await playVerseSequence(newReciter, savedSurah, savedVerse, savedTotal, fullQuran: savedFullQuran);
    } else {
      await playSingleVerse(newReciter, savedSurah, savedVerse);
    }

    if (currentPosition < audioCubit.state.duration && currentPosition > Duration.zero) {
      await audioCubit.seek(currentPosition);
    }
  }

  /// Checks if a verse is downloaded locally and returns its file path.
  Future<String?> _getLocalAudioPath(int surahId, int verse, AudioModel reciter) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${reciter.id}_${surahId}_$verse.mp3';
    final file = File('${dir.path}/$fileName');

    if (await file.exists()) {
      return file.path;
    } else {
      return null;
    }
  }

  Future<void> pause() async {
    await audioCubit.player.pause();
  }

  Future<void> resume() async {
    await audioCubit.player.play();
  }

  /// Stops playback completely and resets all trackers and state.
  Future<void> stop() async {
    await audioCubit.stop();
    _isSequence = false;
    _isFullQuran = false;
    _isRange = false;
    _targetEndSurah = null;
    _targetEndVerse = null;
    emit(QuranPlayerState.initial());
  }

  @override
  Future<void> close() {
    _audioStateSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    return super.close();
  }
}