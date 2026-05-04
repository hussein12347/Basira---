import 'dart:async';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/quran_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:elda3ia_tour/core/services/local_storage_helper.dart';
import 'package:elda3ia_tour/core/utls/functions/show_message.dart';
import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';
import 'package:elda3ia_tour/features/quran/presentation/manger/quran_cubit.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/AudioUtils.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/SurahAudioPlayer.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/add_book_mark_sheet.dart';
import 'package:elda3ia_tour/features/quran/presentation/views/widgets/custom_range_selection_sheet.dart';

import '../../../../core/utls/widgets/app_animations.dart';
import '../../../../generated/l10n.dart';
import '../../data/repos/quran_repo_impl.dart';
import '../manger/audio/audio_quran_cubit.dart';
import '../manger/audio/audio_quran_state.dart';


class QuranView extends StatefulWidget {
  final int surahNumber;
  final int? pageNumber;
  final int? verseNumber;

  const QuranView({
    super.key,
    required this.surahNumber,
    this.pageNumber,
    this.verseNumber,
  });

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  final QuranRepoImpl repo = QuranRepoImpl();
  late PageController pageController;
  List<HighlightVerse> highlightsList = [];
  late List<AudioModel> audios;
  bool isPlayerVisible = true;
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    int initialPage =
        widget.pageNumber ??
            getPageNumber(widget.surahNumber, widget.verseNumber ?? 1);

    pageController = PageController(initialPage: initialPage - 1);
    audios = AudioUtils.audios.map((e) => AudioModel.fromJson(e)).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranCubit>().updateLastRead(
        initialPage,
        getPageData(initialPage)[0]['surah'],
        verse: widget.verseNumber,
      );

      if (widget.verseNumber != null) {
        setState(() {
          highlightsList = [
            HighlightVerse(
              surah: widget.surahNumber,
              verseNumber: widget.verseNumber!,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              page: initialPage,
            ),
          ];
        });

        _highlightTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              final playerState = context.read<QuranPlayerCubit>().state;
              if (playerState.currentSurahId != null &&
                  playerState.currentVerse != null) {
                highlightsList = [
                  HighlightVerse(
                    surah: playerState.currentSurahId!,
                    verseNumber: playerState.currentVerse!,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    page: getPageNumber(
                      playerState.currentSurahId!,
                      playerState.currentVerse!,
                    ),
                  ),
                ];
              } else {
                highlightsList = [];
              }
            });
          }
        });
      } else {
        final playerState = context.read<QuranPlayerCubit>().state;
        if (playerState.currentSurahId != null &&
            playerState.currentVerse != null) {
          setState(() {
            highlightsList = [
              HighlightVerse(
                surah: playerState.currentSurahId!,
                verseNumber: playerState.currentVerse!,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                page: getPageNumber(
                  playerState.currentSurahId!,
                  playerState.currentVerse!,
                ),
              ),
            ];
          });
        }
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    _highlightTimer?.cancel();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
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
      builder: (context) => VerseDetailSheet(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        repo: repo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<QuranPlayerCubit, QuranPlayerState>(
      listener: (context, state) {
        if (state.currentSurahId != null && state.currentVerse != null) {
          final page = getPageNumber(
            state.currentSurahId!,
            state.currentVerse!,
          );

          final playingHighlight = HighlightVerse(
            surah: state.currentSurahId!,
            verseNumber: state.currentVerse!,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            page: page,
          );

          setState(() {
            highlightsList = [playingHighlight];
          });

          if (pageController.hasClients) {
            final currentPage = pageController.page?.toInt() ?? 0;
            if (currentPage != page - 1) {
              pageController.animateToPage(
                page - 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          }
        } else {
          setState(() {
            highlightsList = [];
          });
        }
      },
      builder: (context, state) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: SafeArea(
              child: SurahAudioPlayer(
                audios: audios,
                isVisible: isPlayerVisible,
              ),
            ),
            body: BlocBuilder<QuranCubit, QuranState>(
              builder: (context, quranState) {
                final quranCubit = context.read<QuranCubit>();
                List<HighlightVerse> combinedHighlights = List.from(highlightsList);

                for (var bookmark in quranCubit.bookmarks) {
                  final isAlreadyHighlighted = combinedHighlights.any((h) =>
                  h.surah == bookmark.surahNumber &&
                      h.verseNumber == bookmark.verseNumber);

                  if (!isAlreadyHighlighted) {
                    combinedHighlights.add(
                      HighlightVerse(
                        surah: bookmark.surahNumber,
                        verseNumber: bookmark.verseNumber,
                        color: Color(bookmark.colorValue).withOpacity(0.25),
                        page: getPageNumber(bookmark.surahNumber, bookmark.verseNumber),
                      ),
                    );
                  }
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isPlayerVisible = !isPlayerVisible;
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: SafeArea(
                    bottom: false,
                    child: QuranPageView(
                      pageController: pageController,
                      topBarBuilder: (context, pageIndex) => QuranTopBarWidget(
                        pageController: pageController,
                        currentPage: (pageController.hasClients
                            ? pageController.page!.round()+1
                            : pageController.initialPage+1) ,
                      ),
                      highlights: combinedHighlights,
                      onLongPressStart: (surahNumber, verseNumber, details) async {
                        final existingIndex = quranCubit.bookmarks.indexWhere(
                                (b) => b.surahNumber == surahNumber && b.verseNumber == verseNumber);

                        final bool isBookmarked = existingIndex != -1;
                        final existingBookmark = isBookmarked ? quranCubit.bookmarks[existingIndex] : null;
                        final bool hasNote = isBookmarked && existingBookmark?.note != null && existingBookmark!.note!.trim().isNotEmpty;

                        final RenderBox overlay =
                        Overlay.of(context).context.findRenderObject() as RenderBox;

                        final highlight = HighlightVerse(
                          surah: surahNumber,
                          verseNumber: verseNumber,
                          color: Theme.of(context).primaryColor.withOpacity(0.4),
                          page: pageController.page!.toInt() + 1,
                        );

                        setState(() {
                          highlightsList = [...highlightsList, highlight];
                        });

                        await showMenu<String>(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          position: RelativeRect.fromLTRB(
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                            overlay.size.width - details.globalPosition.dx,
                            overlay.size.height - details.globalPosition.dy,
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
                                  leading: const Icon(Icons.bookmark_remove, color: Colors.redAccent),
                                  title: Text(s.remove_bookmark),
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                            else
                              PopupMenuItem<String>(
                                value: 'add_bookmark',
                                child: ListTile(
                                  leading: const Icon(Icons.bookmark_add_outlined),
                                  title: Text(s.add_bookmark),
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            if (hasNote)
                              PopupMenuItem<String>(
                                value: 'view_note',
                                child: ListTile(
                                  leading: const Icon(Icons.note_alt_outlined),
                                  title: Text(s.view_note),
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'play_single',
                              child: ListTile(
                                leading: const Icon(Icons.play_circle_outline),
                                title: Text(s.play_single_verse),
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'play_to_end',
                              child: ListTile(
                                leading: const Icon(Icons.playlist_play),
                                title: Text(s.play_to_end_of_surah),
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'play_full',
                              child: ListTile(
                                leading: const Icon(Icons.library_music),
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
                            highlightsList = List.from(highlightsList)..remove(highlight);
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
                              await quranCubit.deleteBookmark(existingBookmark!.id!);
                              SnackbarHelper.showSuccess(s.bookmark_removed);
                            }
                            return;
                          }

                          if (value == 'view_note') {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: Row(
                                  children: [
                                    const Icon(Icons.note_alt, color: Colors.blueAccent),
                                    const SizedBox(width: 8),
                                    Text(s.your_note),
                                  ],
                                ),
                                content: SingleChildScrollView(
                                  child: Text(
                                    existingBookmark!.note!,
                                    style: const TextStyle(fontSize: 16, height: 1.5),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(s.close, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (value == 'tafsir') {
                            _showAyahDetails(context, surahNumber, verseNumber);
                            return;
                          }

                          if (value == 'play_custom') {
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

                              final currentCubitReciter =
                                  context.read<QuranPlayerCubit>().state.currentReciter;
                              final String? reciterId =
                              await LocalStorageHelper.getLastReciterId();
                              final AudioModel reciter = currentCubitReciter ??
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
                            return;
                          }

                          if (value == 'copy') {
                            await Clipboard.setData(
                              ClipboardData(
                                text: getVerse(surahNumber, verseNumber),
                              ),
                            );
                            SnackbarHelper.showSuccess(s.copied_to_clipboard);
                            return;
                          }

                          final currentCubitReciter =
                              context.read<QuranPlayerCubit>().state.currentReciter;
                          final String? reciterId =
                          await LocalStorageHelper.getLastReciterId();
                          final AudioModel reciter = currentCubitReciter ??
                              (reciterId == null
                                  ? audios.first
                                  : audios.firstWhere(
                                    (element) => element.id == reciterId,
                              ));

                          if (value == 'play_single' ||
                              value == 'play_to_end' ||
                              value == 'play_full') {
                            if (!isPlayerVisible) {
                              setState(() => isPlayerVisible = true);
                            }
                          }

                          if (value == 'play_single') {
                            await context.read<QuranPlayerCubit>().playSingleVerse(
                              reciter,
                              surahNumber,
                              verseNumber,
                            );
                          } else if (value == 'play_to_end') {
                            final totalVerses = getVerseCount(surahNumber);
                            await context.read<QuranPlayerCubit>().playVerseSequence(
                              reciter,
                              surahNumber,
                              verseNumber,
                              totalVerses,
                              fullQuran: false,
                            );
                          } else if (value == 'play_full') {
                            final totalVerses = getVerseCount(surahNumber);
                            await context.read<QuranPlayerCubit>().playVerseSequence(
                              reciter,
                              surahNumber,
                              verseNumber,
                              totalVerses,
                              fullQuran: true,
                            );
                          }
                        });
                      },
                      onPageChanged: (pageIndex) async {
                        await context.read<QuranCubit>().updateLastRead(
                          pageIndex,
                          getPageData(pageIndex)[0]['surah'],
                        );
                      },
                    ).animateDelayOnly(duration: const Duration(milliseconds: 600)),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class VerseDetailSheet extends StatelessWidget {
  final int surahNumber;
  final int verseNumber;
  final QuranRepoImpl repo;

  const VerseDetailSheet({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
    required this.repo,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final String revelation = getPlaceOfRevelation(surahNumber);
    final pageNumber = getPageNumber(surahNumber, verseNumber);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${s.surah} ${getSurahNameArabic(surahNumber)} - ${s.ayah} $verseNumber',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: s.page,
                          value: '$pageNumber',
                          icon: Icons.find_in_page_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InfoCard(
                          title: s.juz,
                          value: '${getJuzNumber(surahNumber, verseNumber)}',
                          icon: Icons.pie_chart_outline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InfoCard(
                          title: s.revelation,
                          value: revelation == 'Makkah'
                              ? s.revelation_makki
                              : s.revelation_madani,
                          icon: Icons.location_on_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InfoCard(
                          title: s.quarter,
                          value: '${getQuarterNumber(surahNumber, verseNumber)}',
                          icon: Icons.donut_large_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  TafsirSection(
                    title: s.tafsir_moyser,
                    content: repo.getTafsirText(surahNumber, verseNumber),
                    isArabic: true,
                  ),
                  TafsirSection(
                    title: s.tafsir_english,
                    content: repo.getEnTafsir(
                      surahNumber: surahNumber,
                      ayahNumber: verseNumber,
                    ),
                    isArabic: false,
                  ),
                  TafsirSection(
                    title: s.english_translation,
                    content: repo.getEnTranslation(
                      surahNumber: surahNumber,
                      ayahNumber: verseNumber,
                    ),
                    isArabic: false,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor.withOpacity(0.8), size: 24),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            maxLines: 1,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}


class TafsirSection extends StatelessWidget {
  final String title;
  final String content;
  final bool isArabic;

  const TafsirSection({
    super.key,
    required this.title,
    required this.content,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Row(
          children: [
            Icon(
              isArabic ? Icons.library_books_outlined : Icons.translate,
              color: primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        const Divider(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            textAlign: TextAlign.justify,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

