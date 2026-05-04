import 'package:elda3ia_tour/features/home/presentation/views/home.dart';
import 'package:elda3ia_tour/features/setting/presentation/views/setting_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../const/constant.dart';
import '../features/downloads_mangment/presentation/views/download_screen.dart';
import '../features/home/presentation/views/bookmarks_view.dart';
import '../features/nav_bar/presentation/views/nav_bar.dart';
import '../features/quran/presentation/manger/quran_cubit.dart';
import '../features/quran/presentation/views/quran_list_view.dart';
import '../features/quran/presentation/views/quran_search_view.dart';
import '../features/quran/presentation/views/quran_view.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: kHomeRoute,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kFavoriteRoute,
                builder: (context, state) => BookmarksView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kHomeRoute,
                builder: (context, state) => HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kSettingsRoute,
                builder: (context, state) => SettingsView(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: kSearchRoute, builder: (context, state) => const QuranSearchView()),
      GoRoute(
        path: kQuranPageViewRoute,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          final isMushafMode = context.read<QuranCubit>().isMushafMode;

          if (isMushafMode) {
            return QuranView(
              surahNumber: extra['surahNumber']!,
              pageNumber: extra['pageNumber'],
              verseNumber: extra['verseNumber'],
            );
          } else {
            return QuranListView(
              surahNumber: extra['surahNumber']!,
              pageNumber: extra['pageNumber'],
              verseNumber: extra['verseNumber'],
            );
          }
        },
      ),
      GoRoute(
        path: kDownloadsRoute,
        builder: (context, state)=>RecitersDownloadScreen()
      ),
    ],
  );
}
