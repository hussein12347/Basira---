import 'dart:async';
import 'package:elda3ia_tour/core/services/local_storage_helper.dart';
import 'package:elda3ia_tour/core/utls/functions/is_arabic.dart';
import 'package:elda3ia_tour/core/utls/functions/show_message.dart';
import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';
import 'package:elda3ia_tour/features/quran/presentation/manger/quran_cubit.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/AudioUtils.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/SurahAudioPlayer.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/add_book_mark_sheet.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/aya_card.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/aya_details_sheet.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/custom_range_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/utls/widgets/app_animations.dart';
import '../../../../generated/l10n.dart';
import '../../data/repos/quran_repo_impl.dart';
import '../manger/audio/audio_quran_cubit.dart';
import '../manger/audio/audio_quran_state.dart';

class QuranListView extends StatefulWidget {
  final int surahNumber;
  final int? pageNumber;
  final int? verseNumber;

  const QuranListView({
    super.key,
    required this.surahNumber,
    this.pageNumber,
    this.verseNumber,
  });

  @override
  State<QuranListView> createState() => _QuranListViewState();
}

class _QuranListViewState extends State<QuranListView> {
  final repo = QuranRepoImpl();
  late int _selectedSurah;
  List<HighlightVerse> highlightsList = [];
  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  Timer? _saveDebounce;
  Timer? _highlightTimer;
  int _lastSavedAyah = -1;

  late List<AudioModel> audios;
  bool isPlayerVisible = true;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    _selectedSurah = widget.surahNumber;
    audios = AudioUtils.audios.map((e) => AudioModel.fromJson(e)).toList();

    _itemPositionsListener.itemPositions.addListener(_onScrollPositionChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerState = context.read<QuranPlayerCubit>().state;

      if (playerState.currentSurahId == _selectedSurah &&
          playerState.currentVerse != null) {
        setState(() {
          highlightsList = [
            HighlightVerse(
              surah: playerState.currentSurahId!,
              verseNumber: playerState.currentVerse!,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              page: 0,
            ),
          ];
        });

        if (_itemScrollController.isAttached) {
          final targetIndex = playerState.currentVerse!;
          _itemScrollController.jumpTo(index: targetIndex, alignment: 0.0);
        }
      } else if (widget.verseNumber != null) {
        setState(() {
          highlightsList = [
            HighlightVerse(
              surah: _selectedSurah,
              verseNumber: widget.verseNumber!,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              page: 0,
            ),
          ];
        });

        if (_itemScrollController.isAttached) {
          _itemScrollController.jumpTo(
            index: widget.verseNumber!,
            alignment: 0.0,
          );
        }

        context.read<QuranCubit>().updateLastRead(
          widget.pageNumber ??
              getPageNumber(_selectedSurah, widget.verseNumber!),
          _selectedSurah,
          verse: widget.verseNumber,
        );

        _highlightTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              highlightsList = [];
            });
          }
        });
      } else if (widget.pageNumber != null) {
        _scrollToPageTarget(widget.pageNumber!);
        context.read<QuranCubit>().updateLastRead(
          widget.pageNumber!,
          _selectedSurah,
        );
      }
    });
  }

  void _onScrollPositionChanged() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    int topIndex = positions
        .where((position) => position.itemTrailingEdge > 0)
        .reduce(
          (min, position) =>
              position.itemLeadingEdge < min.itemLeadingEdge ? position : min,
        )
        .index;

    int currentAyah = topIndex == 0 ? 1 : topIndex;

    if (currentAyah != _lastSavedAyah) {
      _saveDebounce?.cancel();
      _saveDebounce = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          _lastSavedAyah = currentAyah;
          int page = getPageNumber(_selectedSurah, currentAyah);
          context.read<QuranCubit>().updateLastRead(
            page,
            _selectedSurah,
            verse: currentAyah,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(
      _onScrollPositionChanged,
    );
    _saveDebounce?.cancel();
    _highlightTimer?.cancel();
    WakelockPlus.disable();

    super.dispose();
  }

  void _scrollToPageTarget(int targetPage) {
    int maxAyahs = getVerseCount(_selectedSurah);
    int targetAyahIndex = 0;

    for (int i = 1; i <= maxAyahs; i++) {
      if (getPageNumber(_selectedSurah, i) == targetPage) {
        targetAyahIndex = i;
        break;
      }
    }

    if (_itemScrollController.isAttached) {
      _itemScrollController.jumpTo(index: targetAyahIndex, alignment: 0.0);
    }
  }

  Future<void> _togglePlay(
    int surahNumber,
    int verseNumber,
    bool isThisAyahSelected,
    bool isPlaying,
  ) async {
    final playerCubit = context.read<QuranPlayerCubit>();

    if (isThisAyahSelected) {
      if (isPlaying) {
        await playerCubit.pause();
      } else {
        await playerCubit.resume();
      }
    } else {
      final currentCubitReciter = playerCubit.state.currentReciter;
      final String? reciterId = await LocalStorageHelper.getLastReciterId();

      final AudioModel reciter =
          currentCubitReciter ??
          (reciterId == null
              ? audios.first
              : audios.firstWhere((element) => element.id == reciterId));

      if (!isPlayerVisible) {
        setState(() => isPlayerVisible = true);
      }

      final totalVerses = getVerseCount(surahNumber);
      await playerCubit.playVerseSequence(
        reciter,
        surahNumber,
        verseNumber,
        totalVerses,
        fullQuran: false,
      );
    }
  }

  Future<void> _copyAyah(int surahNumber, int verseNumber) async {
    await Clipboard.setData(
      ClipboardData(text: getVerse(surahNumber, verseNumber)),
    );
    SnackbarHelper.showSuccess(S.of(context).copied_to_clipboard);
  }

  void _showAyahDetails(
    BuildContext context,
    int surahNumber,
    int verseNumber,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AyahDetailSheet(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        repo: repo,
      ),
    );
  }

  Future<void> _showCustomRangeSheet(
    BuildContext context,
    int surahNumber,
    int verseNumber,
  ) async {
    final result = await showModalBottomSheet<Map<String, int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CustomRangeSelectionSheet(
            initialSurah: surahNumber,
            initialVerse: verseNumber,
          ),
        );
      },
    );

    if (result != null) {
      if (!isPlayerVisible) {
        setState(() => isPlayerVisible = true);
      }

      final int sSurah = result['startSurah']!;
      final int sVerse = result['startVerse']!;
      final int eSurah = result['endSurah']!;
      final int eVerse = result['endVerse']!;

      final currentCubitReciter = context
          .read<QuranPlayerCubit>()
          .state
          .currentReciter;
      final String? reciterId = await LocalStorageHelper.getLastReciterId();
      final AudioModel reciter =
          currentCubitReciter ??
          (reciterId == null
              ? audios.first
              : audios.firstWhere((element) => element.id == reciterId));

      await context.read<QuranPlayerCubit>().playVerseRange(
        reciter,
        sSurah,
        sVerse,
        eSurah,
        eVerse,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<QuranPlayerCubit, QuranPlayerState>(
      listener: (context, state) {
        if (state.currentSurahId != null && state.currentVerse != null) {
          if (state.currentSurahId != _selectedSurah) {
            setState(() {
              _selectedSurah = state.currentSurahId!;
            });
          }

          final playingHighlight = HighlightVerse(
            surah: state.currentSurahId!,
            verseNumber: state.currentVerse!,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            page: 0,
          );

          setState(() {
            highlightsList = [playingHighlight];
          });

          if (_itemScrollController.isAttached) {
            final targetIndex = state.currentVerse!;
            _itemScrollController.scrollTo(
              index: targetIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: 0.0,
            );
          }
        } else {
          setState(() {
            highlightsList = [];
          });
        }
      },
      builder: (context, state) {
        final primaryColor = Theme.of(context).colorScheme.primary;

        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedSurah,
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                iconEnabledColor: primaryColor,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                items: List.generate(114, (index) {
                  int surahNum = index + 1;
                  return DropdownMenuItem(
                    value: surahNum,
                    child: Text(
                      '${s.surah} ${LanguageHelper.isArabic() ? getSurahNameArabic(surahNum) : getSurahName(surahNum)}',
                    ),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    final playerState = context.read<QuranPlayerCubit>().state;

                    setState(() {
                      _selectedSurah = value;
                      if (playerState.currentSurahId == value &&
                          playerState.currentVerse != null) {
                        highlightsList = [
                          HighlightVerse(
                            surah: value,
                            verseNumber: playerState.currentVerse!,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            page: 0,
                          ),
                        ];
                      } else {
                        highlightsList = [];
                      }
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_itemScrollController.isAttached) {
                        if (playerState.currentSurahId == value &&
                            playerState.currentVerse != null) {
                          final targetIndex = playerState.currentVerse!;
                          _itemScrollController.jumpTo(
                            index: targetIndex,
                            alignment: 0.0,
                          );
                        } else {
                          _itemScrollController.jumpTo(
                            index: 0,
                            alignment: 0.0,
                          );
                        }
                      }
                    });

                    context.read<QuranCubit>().updateLastRead(
                      getPageNumber(value, 1),
                      value,
                      verse: 1,
                    );
                  }
                },
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.queue_music),
                tooltip: s.play_custom_range,
                onPressed: () {
                  int currentVerse = _lastSavedAyah > 0 ? _lastSavedAyah : 1;
                  _showCustomRangeSheet(context, _selectedSurah, currentVerse);
                },
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: SurahAudioPlayer(audios: audios, isVisible: isPlayerVisible),
          ),
          body: BlocBuilder<QuranCubit, QuranState>(
            builder: (context, quranState) {
              final quranCubit = context.read<QuranCubit>();

              List<HighlightVerse> combinedHighlights = List.from(
                highlightsList,
              );

              for (var bookmark in quranCubit.bookmarks) {
                if (bookmark.surahNumber == _selectedSurah) {
                  final isAlreadyHighlighted = combinedHighlights.any(
                    (h) =>
                        h.surah == bookmark.surahNumber &&
                        h.verseNumber == bookmark.verseNumber,
                  );

                  if (!isAlreadyHighlighted) {
                    combinedHighlights.add(
                      HighlightVerse(
                        surah: bookmark.surahNumber,
                        verseNumber: bookmark.verseNumber,
                        color: Color(bookmark.colorValue).withOpacity(0.25),
                        page: 0,
                      ),
                    );
                  }
                }
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    isPlayerVisible = !isPlayerVisible;
                  });
                },
                behavior: HitTestBehavior.translucent,
                child: QuranSurahListView(
                  surahNumber: _selectedSurah,
                  highlights: combinedHighlights,
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  ayahBuilder:
                      (
                        context,
                        surahNumber,
                        verseNumber,
                        othmanicText,
                        isHighlighted,
                        highlightColor,
                      ) {
                        final bool isThisAyahSelected =
                            state.currentSurahId == surahNumber &&
                            state.currentVerse == verseNumber;
                        final playerCubit = context.read<QuranPlayerCubit>();

                        final existingIndex = quranCubit.bookmarks.indexWhere(
                          (b) =>
                              b.surahNumber == surahNumber &&
                              b.verseNumber == verseNumber,
                        );
                        final bool isBookmarked = existingIndex != -1;
                        final existingBookmark = isBookmarked
                            ? quranCubit.bookmarks[existingIndex]
                            : null;
                        final bool hasNote =
                            isBookmarked &&
                            existingBookmark?.note != null &&
                            existingBookmark!.note!.trim().isNotEmpty;

                        return StreamBuilder<bool>(
                          stream: playerCubit.audioCubit.player.playingStream,
                          initialData: playerCubit.audioCubit.player.playing,
                          builder: (context, snapshot) {
                            final bool isPlaying = snapshot.data ?? false;

                            return GestureDetector(
                              onLongPressStart: (details) async {
                                final RenderBox overlay =
                                    Overlay.of(
                                          context,
                                        ).context.findRenderObject()
                                        as RenderBox;

                                final highlight = HighlightVerse(
                                  surah: surahNumber,
                                  verseNumber: verseNumber,
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.4),
                                  page: 0,
                                );

                                setState(() {
                                  highlightsList = [
                                    ...highlightsList,
                                    highlight,
                                  ];
                                });

                                await showMenu<String>(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  position: RelativeRect.fromLTRB(
                                    details.globalPosition.dx,
                                    details.globalPosition.dy,
                                    overlay.size.width -
                                        details.globalPosition.dx,
                                    overlay.size.height -
                                        details.globalPosition.dy,
                                  ),
                                  items: <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'tafsir',
                                      child: ListTile(
                                        leading: const Icon(Icons.menu_book),
                                        title: Text(s.tafsir_and_translation),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    const PopupMenuDivider(),

                                    if (isBookmarked)
                                      PopupMenuItem<String>(
                                        value: 'remove_bookmark',
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.bookmark_remove,
                                            color: Colors.redAccent,
                                          ),
                                          title: Text(s.remove_bookmark),
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      )
                                    else
                                      PopupMenuItem<String>(
                                        value: 'add_bookmark',
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.bookmark_add_outlined,
                                          ),
                                          title: Text(s.add_bookmark),
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),

                                    if (hasNote)
                                      PopupMenuItem<String>(
                                        value: 'view_note',
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.note_alt_outlined,
                                          ),
                                          title: Text(s.view_note),
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),

                                    const PopupMenuDivider(),

                                    PopupMenuItem<String>(
                                      value: 'play_single',
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.play_circle_outline,
                                        ),
                                        title: Text(s.play_single_verse),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'play_to_end',
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.playlist_play,
                                        ),
                                        title: Text(s.play_to_end_of_surah),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'play_full',
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.library_music,
                                        ),
                                        title: Text(s.play_full_quran),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'play_custom',
                                      child: ListTile(
                                        leading: const Icon(Icons.queue_music),
                                        title: Text(s.play_custom_range),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'copy',
                                      child: ListTile(
                                        leading: const Icon(Icons.copy),
                                        title: Text(s.copy_verse),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                  ],
                                ).then((value) async {
                                  setState(() {
                                    highlightsList = List.from(highlightsList)
                                      ..remove(highlight);
                                  });

                                  if (value == 'add_bookmark') {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => AddBookmarkSheet(
                                        surahNumber: surahNumber,
                                        verseNumber: verseNumber,
                                      ),
                                    );
                                    return;
                                  }

                                  if (value == 'remove_bookmark') {
                                    if (existingBookmark?.id != null) {
                                      await quranCubit.deleteBookmark(
                                        existingBookmark!.id!,
                                      );
                                      SnackbarHelper.showSuccess(
                                        s.bookmark_removed,
                                      );
                                    }
                                    return;
                                  }

                                  if (value == 'view_note') {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            const Icon(
                                              Icons.note_alt,
                                              color: Colors.blueAccent,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(s.your_note),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            existingBookmark!.note!,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              s.close,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  if (value == 'tafsir') {
                                    _showAyahDetails(
                                      context,
                                      surahNumber,
                                      verseNumber,
                                    );
                                    return;
                                  }

                                  if (value == 'play_custom') {
                                    _showCustomRangeSheet(
                                      context,
                                      surahNumber,
                                      verseNumber,
                                    );
                                    return;
                                  }

                                  if (value == 'copy') {
                                    _copyAyah(surahNumber, verseNumber);
                                    return;
                                  }

                                  final currentCubitReciter = context
                                      .read<QuranPlayerCubit>()
                                      .state
                                      .currentReciter;
                                  final String? reciterId =
                                      await LocalStorageHelper.getLastReciterId();
                                  final AudioModel reciter =
                                      currentCubitReciter ??
                                      (reciterId == null
                                          ? audios.first
                                          : audios.firstWhere(
                                              (element) =>
                                                  element.id == reciterId,
                                            ));

                                  if (value == 'play_single' ||
                                      value == 'play_to_end' ||
                                      value == 'play_full') {
                                    if (!isPlayerVisible) {
                                      setState(() => isPlayerVisible = true);
                                    }
                                  }

                                  if (value == 'play_single') {
                                    await context
                                        .read<QuranPlayerCubit>()
                                        .playSingleVerse(
                                          reciter,
                                          surahNumber,
                                          verseNumber,
                                        );
                                  } else if (value == 'play_to_end') {
                                    final totalVerses = getVerseCount(
                                      surahNumber,
                                    );
                                    await context
                                        .read<QuranPlayerCubit>()
                                        .playVerseSequence(
                                          reciter,
                                          surahNumber,
                                          verseNumber,
                                          totalVerses,
                                          fullQuran: false,
                                        );
                                  } else if (value == 'play_full') {
                                    final totalVerses = getVerseCount(
                                      surahNumber,
                                    );
                                    await context
                                        .read<QuranPlayerCubit>()
                                        .playVerseSequence(
                                          reciter,
                                          surahNumber,
                                          verseNumber,
                                          totalVerses,
                                          fullQuran: true,
                                        );
                                  }
                                });
                              },
                              child: AyahCard(
                                verseNumber: verseNumber,
                                othmanicText: othmanicText,
                                isHighlighted: isHighlighted,
                                englishTranslation: QuranRepoImpl()
                                    .getEnTranslation(
                                      surahNumber: surahNumber,
                                      ayahNumber: verseNumber,
                                    ),
                                englishTafsir: QuranRepoImpl().getEnTafsir(

                                  surahNumber: surahNumber,
                                  ayahNumber: verseNumber,
                                ),
                                highlightColor: highlightColor,
                                isPlaying: isPlaying,
                                isThisAyahSelected: isThisAyahSelected,
                                isBookmarked: isBookmarked,
                                hasNote: hasNote,

                                onInfo: () => _showAyahDetails(
                                  context,
                                  surahNumber,
                                  verseNumber,
                                ),
                                onBookmark: () {
                                  if (isBookmarked) {
                                    if (existingBookmark?.id != null) {
                                      quranCubit.deleteBookmark(
                                        existingBookmark!.id!,
                                      );
                                      SnackbarHelper.showSuccess(
                                        s.bookmark_removed,
                                      );
                                    }
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => AddBookmarkSheet(
                                        surahNumber: surahNumber,
                                        verseNumber: verseNumber,
                                      ),
                                    );
                                  }
                                },

                                onViewNote: hasNote
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Row(
                                              children: [
                                                const Icon(
                                                  Icons.note_alt,
                                                  color: Colors.blueAccent,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(s.your_note),
                                              ],
                                            ),
                                            content: SingleChildScrollView(
                                              child: Text(
                                                existingBookmark.note!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  s.close,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    : null,

                                onCopy: () =>
                                    _copyAyah(surahNumber, verseNumber),
                                onTogglePlay: () => _togglePlay(
                                  surahNumber,
                                  verseNumber,
                                  isThisAyahSelected,
                                  isPlaying,
                                ),
                              ),
                            ).animateDelayOnly(
                              duration: const Duration(milliseconds: 600),
                            );
                          },
                        );
                      },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
