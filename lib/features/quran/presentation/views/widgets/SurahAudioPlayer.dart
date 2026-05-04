import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../core/services/local_storage_helper.dart';
import '../../../../../core/utls/audio_state/audio_cubit.dart';
import '../../../../../core/utls/audio_state/audio_state.dart';
import '../../../../../core/utls/functions/is_arabic.dart';
import '../../../../../core/utls/styles/app_styles.dart';
import '../../../../../generated/l10n.dart';
import '../../manger/audio/audio_quran_cubit.dart';
import '../../manger/audio/audio_quran_state.dart';

/// A persistent mini-player widget for Quranic audio recitation.
///
/// **Key Features:**
/// - Reactive UI: Automatically hides when no audio is active.
/// - Dynamic Visibility: Can be toggled manually via the [isVisible] parameter.
/// - Reciter Selection: Integrated dialog with automatic scrolling to the current selection.
/// - Playback Control: Supports Play/Pause, Stop (Full reset), and Verse Repetition.
class SurahAudioPlayer extends StatelessWidget {
  /// The global list of available reciters.
  final List<AudioModel> audios;

  /// Controls whether the player is visible when an audio is active.
  final bool isVisible;

  const SurahAudioPlayer({
    super.key,
    required this.audios,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranPlayerCubit, QuranPlayerState>(
      builder: (context, quranState) {
        // Observe the global audio cubit state for playback status
        final audioState = context.watch<AudioCubit>().state;

        // 💡 1. Absolute Hide Logic: If no Surah or Verse is selected, remove from tree.
        if (quranState.currentSurahId == null || quranState.currentVerse == null) {
          return const SizedBox.shrink();
        }

        final reciter = quranState.currentReciter ?? audios.first;

        // 💡 2. Smooth Transition: Use AnimatedSize for expanding/collapsing based on isVisible.
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isVisible
              ? _buildPlayerUI(context, quranState, audioState, reciter)
              : const SizedBox.shrink(),
        );
      },
    );
  }

  /// Builds the main decorative container for the player.
  Widget _buildPlayerUI(
      BuildContext context,
      QuranPlayerState quranState,
      AudioState audioState,
      AudioModel reciter,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPlayerControls(context, quranState, audioState, reciter),
        ],
      ),
    );
  }

  /// Constructs the playback control row including reciter info and action buttons.
  Widget _buildPlayerControls(
      BuildContext context,
      QuranPlayerState quranState,
      AudioState audioState,
      AudioModel reciter,
      ) {
    final theme = Theme.of(context);
    final audioCubit = context.read<AudioCubit>();
    final quranPlayerCubit = context.read<QuranPlayerCubit>();

    // Determine if the player is currently pre-buffering or loading data.
    final isLoading = audioState.processingState == ProcessingState.buffering ||
        audioState.processingState == ProcessingState.loading;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --- Play/Pause/Loading Button ---
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: isLoading
              ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary
                )
            ),
          )
              : IconButton(
            iconSize: 34,
            onPressed: () {
              // Directly command the core player for immediate response
              if (audioCubit.player.playing) {
                audioCubit.player.pause();
              } else {
                audioCubit.player.play();
              }
            },
            icon: Icon(
              audioState.isPlaying
                  ? CupertinoIcons.pause_solid
                  : CupertinoIcons.play_arrow_solid,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // --- Reciter Info & Surah Details ---
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showReciterDialog(context, quranPlayerCubit, reciter),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  backgroundImage: AssetImage("assets/images/png/${reciter.id}.jpg"),
                  onBackgroundImageError: (_, _) => const Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageHelper.isArabic() ? reciter.nameAr! : reciter.nameEn!,
                        style: AppStyles.medium18(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${S.of(context).surah} ${quranState.currentSurahId ?? '-'} | ${S.of(context).verse} ${quranState.currentVerse ?? '-'}',
                        style: AppStyles.regular14(context).copyWith(
                          color: theme.hintColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // --- Stop and Repeat Actions ---
        IconButton(
          tooltip: S.of(context).stop,
          iconSize: 26,
          onPressed: () => quranPlayerCubit.stop(),
          icon: Icon(
            CupertinoIcons.stop_circle_fill,
            color: Colors.grey[500],
          ),
        ),
        IconButton(
          tooltip: quranState.isRepeating ? S.of(context).disable_repeat : S.of(context).repeat_verse,
          iconSize: 26,
          onPressed: quranPlayerCubit.toggleRepeat,
          icon: Icon(
            CupertinoIcons.repeat_1,
            color: quranState.isRepeating ? theme.colorScheme.secondary : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  /// Displays a dialog to switch the current reciter.
  ///
  /// Automatically scrolls to and highlights the currently selected reciter
  /// using [ScrollablePositionedList].
  void _showReciterDialog(
      BuildContext context,
      QuranPlayerCubit quranPlayerCubit,
      AudioModel currentReciter,
      ) {
    final theme = Theme.of(context);
    final ItemScrollController scrollController = ItemScrollController();
    final selectedIndex = audios.indexWhere((r) => r.id == currentReciter.id);

    showDialog(
      context: context,
      builder: (context) {
        // Auto-scroll logic after the frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selectedIndex != -1) {
            scrollController.scrollTo(
              index: selectedIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: theme.cardColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LanguageHelper.isArabic() ? "اختر القارئ" : "Select Reciter",
                  style: AppStyles.bold20(context).copyWith(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ScrollablePositionedList.builder(
                    itemCount: audios.length,
                    itemScrollController: scrollController,
                    itemBuilder: (context, index) {
                      final reciter = audios[index];
                      final isSelected = reciter.id == currentReciter.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            // Update reciter in logic and persistence layer
                            quranPlayerCubit.changeReciter(reciter);
                            await LocalStorageHelper.saveLastReciter(reciter.id.toString());
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                                  backgroundImage: AssetImage("assets/images/png/${reciter.id}.jpg"),
                                  onBackgroundImageError: (_, _) => const Icon(Icons.person),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LanguageHelper.isArabic() ? reciter.nameAr! : reciter.nameEn!,
                                        style: AppStyles.medium18(context).copyWith(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        LanguageHelper.isArabic()
                                            ? "${reciter.musshafTypeAr} - ${reciter.rewayaAr}"
                                            : '${reciter.musshafTypeEn} - ${reciter.rewayaEn}',
                                        style: AppStyles.regular14(context).copyWith(color: theme.hintColor),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle, color: theme.colorScheme.primary),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}