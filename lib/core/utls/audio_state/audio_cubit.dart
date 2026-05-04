import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'audio_state.dart';

/// A [Cubit] that manages the state of the audio player.
///
/// It acts as a bridge between the [AudioPlayer] and the UI, listening to
/// various player streams (state, duration, position, sequence) and emitting
/// corresponding [AudioState] updates.
class AudioCubit extends Cubit<AudioState> {
  /// The underlying just_audio player instance.
  final AudioPlayer player;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _sequenceStateSubscription;

  /// Initializes the cubit, turns off loop mode by default, and sets up
  /// listeners for the player's event streams.
  AudioCubit(this.player) : super(AudioState.initial()) {
    player.setLoopMode(LoopMode.off);
    _listenToPlayer();
  }

  /// Subscribes to the audio player's streams to keep the state in sync.
  void _listenToPlayer() {
    // Listen to play/pause state and buffering status
    _playerStateSubscription = player.playerStateStream.listen((playerState) {
      emit(state.copyWith(
        processingState: playerState.processingState,
        isPlaying: playerState.playing,
      ));
    });

    // Listen to the total duration of the current audio
    _durationSubscription = player.durationStream.listen((d) {
      emit(state.copyWith(duration: d ?? Duration.zero));
    });

    // Listen to the current playback position
    _positionSubscription = player.positionStream.listen((p) {
      emit(state.copyWith(position: p));
    });

    // Listen to playlist/sequence changes (current track, media item info)
    _sequenceStateSubscription = player.sequenceStateStream.listen((sequenceState) {
      final index = sequenceState.currentIndex ?? 0;
      final mediaItem = sequenceState.currentSource?.tag as MediaItem?;
      emit(state.copyWith(
        currentIndex: index,
        currentMediaItem: mediaItem,
      ));
    });
  }

  /// Loads a playlist and starts playing it immediately.
  ///
  /// [playlist] is the sequence of audio sources.
  /// [initialIndex] optionally specifies which track to start playing first.
  Future<void> setAndPlayPlaylist(
      ConcatenatingAudioSource playlist, {
        int initialIndex = 0,
      }) async {
    try {
      await player.setAudioSource(
        playlist,
        initialIndex: initialIndex,
        initialPosition: Duration.zero,
      );
      await player.play();
    } catch (e) {
      print("Error setting playlist: $e");
      emit(AudioState.initial());
    }
  }

  /// Loads and plays a single audio source.
  Future<void> playAudio(AudioSource source) async {
    try {
      await player.setAudioSource(source);
      await player.play();
    } catch (e) {
      print("Error playing audio source: $e");
      emit(AudioState.initial());
    }
  }

  /// Pauses the current audio playback.
  Future<void> pause() async {
    await player.pause();
  }

  /// Resumes the paused audio playback.
  Future<void> resume() async {
    await player.play();
  }

  /// Stops the audio playback entirely.
  Future<void> stop() async {
    await player.stop();
  }

  /// Seeks to a specific [position] within the current audio.
  ///
  /// The [index] parameter can be used to seek to a specific track in a playlist.
  Future<void> seek(Duration position, {int? index}) async {
    await player.seek(position, index: index);
  }

  // ==========================================
  // Playlist Navigation Methods
  // ==========================================

  /// Skips to the next track in the active playlist.
  Future<void> seekToNext() async {
    await player.seekToNext();
  }

  /// Skips to the previous track in the active playlist.
  Future<void> seekToPrevious() async {
    await player.seekToPrevious();
  }

  /// Cleans up stream subscriptions and disposes of the player to prevent memory leaks.
  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _sequenceStateSubscription?.cancel();
    player.dispose();
    return super.close();
  }
}