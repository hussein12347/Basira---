// 💡 File 1: audio_state.dart
// 💡 This represents the "global" state of the audio player.

import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Represents the state of the audio player at any given moment.
///
/// Uses [Equatable] to allow for easy value comparisons, which is crucial
/// for Bloc/Cubit state management to avoid unnecessary UI rebuilds.
class AudioState extends Equatable {
  /// The current processing state of the player (e.g., idle, loading, ready, completed).
  final ProcessingState processingState;

  /// Indicates whether the audio is currently playing.
  final bool isPlaying;

  /// The total duration of the current audio item.
  final Duration duration;

  /// The current playback position of the audio item.
  final Duration position;

  /// Metadata of the currently playing audio item (e.g., title, artist, artwork).
  /// 💡 Added: To know what is currently being played.
  final MediaItem? currentMediaItem;

  /// The index of the currently playing item within a playlist.
  final int? currentIndex;

  /// The playback speed multiplier (default is 1.0).
  final double speed;

  /// Constructs an [AudioState].
  const AudioState({
    required this.processingState,
    required this.isPlaying,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.currentMediaItem,
    this.currentIndex,
    this.speed = 1.0,
  });

  /// Factory constructor to create the initial, default state of the audio player.
  factory AudioState.initial() {
    return const AudioState(
      processingState: ProcessingState.idle,
      isPlaying: false,
      speed: 1.0,
    );
  }

  /// Creates a copy of the current [AudioState] with specific properties replaced.
  ///
  /// This is essential for immutable state updates in Bloc/Cubit.
  AudioState copyWith({
    ProcessingState? processingState,
    bool? isPlaying,
    Duration? duration,
    Duration? position,
    MediaItem? currentMediaItem,
    int? currentIndex,
    double? speed,
  }) {
    return AudioState(
      processingState: processingState ?? this.processingState,
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      currentMediaItem: currentMediaItem ?? this.currentMediaItem,
      currentIndex: currentIndex ?? this.currentIndex,
      speed: speed ?? this.speed,
    );
  }

  /// Properties to be compared by [Equatable] to determine state changes.
  @override
  List<Object?> get props => [
    processingState,
    isPlaying,
    duration,
    position,
    currentMediaItem,
    currentIndex,
    speed,
  ];
}