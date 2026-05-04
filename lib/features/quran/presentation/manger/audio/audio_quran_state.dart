// 💡 File 3: quran_player_state.dart
// 💡 This is the dedicated state class for the Quran Player.

import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';
import 'package:equatable/equatable.dart';

/// Represents the current state of the Quran audio player.
///
/// Extends [Equatable] to allow Bloc to efficiently compare state changes
/// and prevent unnecessary UI rebuilds.
class QuranPlayerState extends Equatable {
  /// Whether the currently playing verse is set to repeat continuously.
  final bool isRepeating;

  /// The metadata of the currently selected reciter.
  final AudioModel? currentReciter;

  /// The 1-based ID of the Surah currently being played.
  final int? currentSurahId;

  /// The number of the verse currently being played.
  final int? currentVerse;

  /// The starting verse number of the active playlist/sequence.
  ///
  /// 💡 Crucial for tracking the exact position within the constructed [ConcatenatingAudioSource].
  final int? startVerse;

  /// The total number of verses in the current playback sequence.
  final int totalVerses;

  const QuranPlayerState({
    required this.isRepeating,
    this.currentReciter,
    this.currentSurahId,
    this.currentVerse,
    this.startVerse,
    this.totalVerses = 0,
  });

  /// Factory constructor to generate the default initial state.
  factory QuranPlayerState.initial() {
    return const QuranPlayerState(
      isRepeating: false,
    );
  }

  /// Creates a copy of the current state while replacing the specified fields
  /// with new values.
  QuranPlayerState copyWith({
    bool? isRepeating,
    AudioModel? currentReciter,
    int? currentSurahId,
    int? currentVerse,
    int? startVerse,
    int? totalVerses,
  }) {
    return QuranPlayerState(
      isRepeating: isRepeating ?? this.isRepeating,
      currentReciter: currentReciter ?? this.currentReciter,
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentVerse: currentVerse ?? this.currentVerse,
      startVerse: startVerse ?? this.startVerse,
      totalVerses: totalVerses ?? this.totalVerses,
    );
  }

  /// The list of properties that determine if two states are considered equal.
  @override
  List<Object?> get props => [
    isRepeating,
    currentReciter,
    currentSurahId,
    currentVerse,
    startVerse,
    totalVerses,
  ];
}