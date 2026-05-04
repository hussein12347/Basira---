import 'package:elda3ia_tour/const/constant.dart';
import 'package:elda3ia_tour/core/utls/styles/app_styles.dart';
import 'package:elda3ia_tour/features/home/presentation/views/widgets/hizb_list.dart';
import 'package:elda3ia_tour/features/home/presentation/views/widgets/juz_list.dart';
import 'package:elda3ia_tour/features/home/presentation/views/widgets/surahs_list.dart';
import 'package:elda3ia_tour/features/quran/presentation/manger/quran_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

import '../../../../const/resource.dart';
import '../../../../core/utls/functions/convert_to_arabic.dart';
import '../../../../core/utls/functions/is_arabic.dart';
import '../../../../core/utls/widgets/app_animations.dart';
import '../../../../generated/l10n.dart';

/// The main entry point and dashboard of the Quran application.
///
/// It features a dynamic header, a "Last Read" quick-access card that
/// updates reactively via [QuranCubit], and a sticky TabBar for navigating
/// between Surahs, Juzs, and Hizbs. It also checks for app updates on startup.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    // Silently check for and apply critical app updates upon opening the home screen
    _checkForUpdateOnStart();
  }

  /// Communicates with the Google Play Store to check for available updates.
  /// If an update is available, it prompts an immediate update flow.
  Future<void> _checkForUpdateOnStart() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      // Fail silently to not disrupt the user experience if the check fails
      print("Error checking for update: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Length updated to 3 to match the active tabs
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          bottom: false,
          // NestedScrollView enables the header to scroll away while keeping the tabs pinned
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ==========================================
                // Global Header (Title & Search Icon)
                // ==========================================
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).quran,
                        style: AppStyles.semiBold24(context).copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.push(kSearchRoute);
                        },
                        icon: Icon(CupertinoIcons.search, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ).animateSlideTopToNormal(
                    duration: const Duration(milliseconds: 600),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 25)),

                // ==========================================
                // Reactive "Last Read" Card
                // ==========================================
                SliverToBoxAdapter(
                  child: BlocBuilder<QuranCubit, QuranState>(
                    builder: (context, state) {
                      // Retrieve the most recent reading session data directly from the Cubit
                      final cubit = context.read<QuranCubit>();
                      final lastSurah = cubit.lastSurah;
                      final lastPage = cubit.lastPage;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                // Jump directly back into the Quran reader if reading history exists
                                if (lastSurah != null) {
                                  context.push(
                                    kQuranPageViewRoute,
                                    extra: {
                                      "surahNumber": lastSurah,
                                      "pageNumber": lastPage,
                                    },
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.menu_book_rounded,
                                                color: Colors.white70,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                S.of(context).lastRead,
                                                style: AppStyles.regular16(context).copyWith(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: AlignmentDirectional.centerStart,
                                            child: Text(
                                              lastSurah == null
                                                  ? ''
                                                  : '${S.of(context).surah}: ${LanguageHelper.isArabic() ? getSurahNameArabic(lastSurah) : getSurahName(lastSurah)}',
                                              style: AppStyles.regular16(context).copyWith(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          if (lastPage != null)
                                            Text(
                                              '${S.of(context).page}: ${LanguageHelper.isArabic() ? ConvertToArabic.convertToArabicNumber(lastPage) : lastPage}',
                                              style: AppStyles.regular16(context).copyWith(
                                                color: Colors.white.withOpacity(0.9),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Decorative Mushaf image
                                    SizedBox(
                                      height: 100,
                                      width: 120,
                                      child: Image.asset(
                                        R.assetsImagesPngMushafPng,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).animateZoomInStart(duration: const Duration(milliseconds: 700)),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ==========================================
                // Sticky TabBar Header
                // ==========================================
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      indicatorWeight: 3.0,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: S.of(context).surah),
                        Tab(text: S.of(context).juz),
                        Tab(text: S.of(context).hizb),
                      ],
                    ).animateDelayOnly(
                      delay: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
              ];
            },

            // ==========================================
            // Tab Content Views
            // ==========================================
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const TabBarView(
                children: [
                  SurahsList(),
                  JuzList(),
                  HizbList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Helper Delegate for Sticky TabBar
// =============================================================================

/// A custom delegate that forces a standard [TabBar] to act as a sticky header
/// inside a [CustomScrollView]. It maintains a solid background color to prevent
/// the scrolling content from showing through the tabs.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // Ensures a solid background color to hide the scrolling content underneath
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Ensure the TabBar repaints if the theme or language changes
  }
}