import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

import '../../../../../generated/l10n.dart';

import '../../../../const/constant.dart';
import '../../../../core/utls/functions/is_arabic.dart';
import '../../../quran/presentation/manger/quran_cubit.dart';

/// A screen that displays all the user's saved Quranic bookmarks.
///
/// It listens to the [QuranCubit] state and presents a list of cards.
/// Each card shows the Surah name, Ayah number, Page number, the actual
/// verse text, and any user-added notes. Tapping a card navigates the user
/// directly to that specific verse in the Quran reader.
class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});

  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  @override
  void initState() {
    super.initState();
    // 💡 Fetch the latest bookmarks from the local database upon opening the screen
    context.read<QuranCubit>().fetchBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.bookmarks),
        centerTitle: true,
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final bookmarks = context.read<QuranCubit>().bookmarks;

          // ==========================================
          // Empty State
          // ==========================================
          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    s.no_bookmarks,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // ==========================================
          // Bookmarks List
          // ==========================================
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            // Added +1 to inject a bottom spacer for BottomNavigationBar clearance
            itemCount: bookmarks.length + 1,
            itemBuilder: (context, index) {
              if (index >= bookmarks.length) {
                return const SizedBox(height: kBottomNavigationBarHeight + 27);
              }

              final bookmark = bookmarks[index];
              final int pageNum = getPageNumber(bookmark.surahNumber, bookmark.verseNumber);
              final Color bookmarkColor = Color(bookmark.colorValue);

              // 💡 Fetch the actual Arabic text of the verse
              final String ayahText = getVerse(bookmark.surahNumber, bookmark.verseNumber).replaceAll('\n', ' ');

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  // Use the user's chosen bookmark color for the card's border
                  side: BorderSide(color: bookmarkColor.withOpacity(0.5), width: 1.5),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // 💡 Navigate to the Quran reader, jumping directly to the bookmarked verse
                    context.push(
                      kQuranPageViewRoute,
                      extra: {
                        "surahNumber": bookmark.surahNumber,
                        "pageNumber": pageNum,
                        "verseNumber": bookmark.verseNumber,
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- 1. Card Header: Surah Info, Ayah, Page & Delete Button ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: bookmarkColor.withOpacity(0.15),
                                  child: Icon(Icons.bookmark, color: bookmarkColor),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${s.surah} ${LanguageHelper.isArabic() ? getSurahNameArabic(bookmark.surahNumber) : getSurahName(bookmark.surahNumber)}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${s.ayah} ${bookmark.verseNumber} • ${s.page} $pageNum",
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Delete Bookmark Action
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              tooltip: s.delete_bookmark,
                              onPressed: () {
                                if (bookmark.id != null) {
                                  context.read<QuranCubit>().deleteBookmark(bookmark.id!);
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // --- 2. Verse Text Display ---
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primaryColor.withOpacity(0.1)),
                          ),
                          child: Text(
                            ayahText, // 💡 The actual verse text
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'hafs',
                              fontSize: 20,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              height: 1.7,
                            ),
                          ),
                        ),

                        // --- 3. Note Display (If the user added one) ---
                        if (bookmark.note != null && bookmark.note!.trim().isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.note_alt_outlined, size: 18, color: Colors.blueAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  bookmark.note!,
                                  style: const TextStyle(fontSize: 14, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}