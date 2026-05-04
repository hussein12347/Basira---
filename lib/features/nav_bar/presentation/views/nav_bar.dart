import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../const/resource.dart';
import '../../../../core/utls/widgets/app_animations.dart';

/// A custom floating bottom navigation bar.
///
/// Implemented as a [StatelessWidget] because [go_router] internally manages
/// the state of the active tab via the [StatefulNavigationShell].
class NavBar extends StatelessWidget {
  /// The navigation shell provided by [go_router] to manage the nested routes (branches).
  final StatefulNavigationShell navigationShell;

  const NavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // List of SVG icons representing the tabs.
    // Ensure the order matches the branches defined in your AppRouter.
    final List<String> icons = [
      R.assetsImagesSvgHeartSvg,
      R.assetsImagesSvgHomeSvg,
      R.assetsImagesSvgSettingSvg,
    ];

    // Retrieve the currently active tab index directly from the navigation shell.
    final int currentIndex = navigationShell.currentIndex;

    return Scaffold(
      extendBody: true,
      // The body is the navigation shell itself, which automatically displays
      // the current branch's UI.
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(left: 32, right: 32, bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(.7),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 15),
                  blurRadius: 25,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                // Generate tab items based on the number of icons provided.
                children: List.generate(
                  icons.length,
                      (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Active Tab Indicator (Animated top line)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 6),
                        width: currentIndex == index ? 20 : 0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      // Tab Icon
                      GestureDetector(
                        onTap: () {
                          // Switch branches using go_router.
                          navigationShell.goBranch(
                            index,
                            // If tapping the current tab, pop back to the initial location of that branch.
                            initialLocation: index == navigationShell.currentIndex,
                          );
                        },
                        // Clean conditional rendering to animate only the active icon.
                        child: (currentIndex == index)
                            ? _buildSvgIcon(context, icons[index], true)
                            .animateSlideTopToNormal(
                          duration: const Duration(milliseconds: 350),
                        )
                            : _buildSvgIcon(context, icons[index], false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to build the SVG icon, preventing code duplication.
  ///
  /// Dynamically updates the color based on the [isActive] state and the
  /// current application theme (Dark/Light mode).
  Widget _buildSvgIcon(BuildContext context, String iconPath, bool isActive) {
    return SvgPicture.asset(
      iconPath,
      height: 25,
      width: 30,
      // Uses [colorFilter] instead of the deprecated [color] property to ensure
      // compatibility with newer versions of flutter_svg.
      colorFilter: ColorFilter.mode(
        isActive
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        BlendMode.srcIn,
      ),
    );
  }
}