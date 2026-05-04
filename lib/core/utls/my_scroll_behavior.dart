import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A custom scroll behavior that overrides the default Material scroll settings.
///
/// This class is particularly useful for cross-platform apps (Web/Desktop)
/// as it enables dragging scrollable widgets with a mouse or trackpad.
/// It also unifies the scroll physics and scrollbar appearance across the app.
///
/// **Usage:**
/// Add this to your `MaterialApp`:
/// ```dart
/// MaterialApp(
///   scrollBehavior: MyCustomScrollBehavior(),
///   ...
/// )
/// ```
class MyCustomScrollBehavior extends MaterialScrollBehavior {

  /// Defines which devices are allowed to drag scrollable areas.
  ///
  /// By default, Flutter desktop/web requires using the scroll wheel.
  /// Adding [PointerDeviceKind.mouse] and [PointerDeviceKind.trackpad]
  /// enables click-and-drag scrolling, mimicking touch behavior.
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };

  /// Forces the application to use [BouncingScrollPhysics] globally.
  ///
  /// This provides the iOS-style "bounce" effect when reaching the edge
  /// of a scrollable area, instead of the default Android overscroll glow.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  /// Customizes the global appearance of scrollbars.
  ///
  /// It applies a uniform thickness, rounded corners, and ensures the
  /// scrollbar is properly linked to its scrollable content.
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(
      // ✅ Links the controller to ensure the scrollbar updates correctly
      controller: details.controller,
      thickness: 8,
      radius: const Radius.circular(10),
      child: child,
    );
  }
}