import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A set of helpful extensions on [Widget] to quickly apply beautiful
/// predefined animations using the `flutter_animate` package.
extension WidgetAnimationExtension on Widget {

  // ==========================================
  // Delay & Simple Fade Animations
  // ==========================================

  /// Waits for a specified [delay] then fades the widget in smoothly.
  ///
  /// Useful for creating staggered animations where items appear one after another.
  Widget animateDelayOnly({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .fadeIn(
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  // ==========================================
  // Slide & Move Animations
  // ==========================================

  /// Slides the widget horizontally into its final position while fading in.
  ///
  /// [isFromStart] determines the direction: if true, it slides from the right (or leading edge).
  Widget animateRightLeft({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    bool isFromStart = true,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeInOutQuart)
        .moveX(
      begin: isFromStart ? 50 : -50,
      end: 0,
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Slides the widget vertically into its final position while fading in.
  ///
  /// [isFromBottom] determines the direction: if true, it slides up from the bottom.
  Widget animateBottomToTop({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    bool isFromBottom = true,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeInOutQuart)
        .moveY(
      begin: isFromBottom ? 50 : -50,
      end: 0,
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// A basic slide animation from the top down to its normal position.
  Widget animateSlideTopToNormal({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .slide(duration: duration)
        .callback(callback: (_) => onComplete?.call());
  }

  // ==========================================
  // Attention Seekers & Effects (Shimmer, Shake)
  // ==========================================

  /// Animates the widget from a desaturated (gray) state to its normal colors.
  ///
  /// [isRepeat] allows the effect to pulse indefinitely.
  Widget animateHalfGrayToNormalColorRepeated({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    bool isRepeat = true,
    VoidCallback? onComplete,
  }) {
    return animate(
      delay: delay,
      onPlay: isRepeat ? (controller) => controller.repeat(reverse: true) : null,
    )
        .desaturate(
      begin: 0.5,
      end: 1.0,
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Applies a sweeping shimmer lighting effect across the widget.
  ///
  /// Highly recommended for buttons, icons, or premium UI elements.
  Widget animateShimmer({
    List<Color>? colors,
    Duration duration = const Duration(milliseconds: 1500),
    Duration delay = Duration.zero,
    bool isRepeat = true,
    VoidCallback? onComplete,
  }) {
    return animate(
      delay: delay,
      onPlay: isRepeat ? (controller) => controller.repeat(reverse: true) : null,
    )
        .shimmer(duration: duration, colors: colors)
        .callback(callback: (_) => onComplete?.call());
  }

  /// Rapidly shakes the widget horizontally to grab the user's attention.
  ///
  /// Ideal for indicating errors, invalid inputs, or critical alerts.
  Widget animateShakeAlarm({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    bool isRepeat = true,
    VoidCallback? onComplete,
  }) {
    return animate(
      delay: delay,
      onPlay: isRepeat ? (controller) => controller.repeat() : null,
    )
        .shake(hz: 10, duration: duration)
        .callback(callback: (_) => onComplete?.call());
  }

  // ==========================================
  // 3D Flips & Rotations
  // ==========================================

  /// Flips the widget into place along the vertical axis.
  Widget animateFlipVertical({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    Alignment alignment = Alignment.center,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .flipV(
      alignment: alignment,
      begin: 0.5,
      end: 0,
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Flips the widget into place along the horizontal axis.
  Widget animateFlipHorizontal({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    Alignment alignment = Alignment.center,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .flipH(
      alignment: alignment,
      begin: 0.5,
      end: 0,
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Rotates the widget into its final position like a spinning entry.
  Widget animateRotate({
    Duration duration = const Duration(seconds: 1),
    Duration delay = Duration.zero,
    Alignment alignment = Alignment.center,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .rotate(
      alignment: alignment,
      begin: 0.5,
      end: 1,
      curve: Curves.easeInOutQuart,
      duration: duration,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  // ==========================================
  // Scaling & Zoom Animations
  // ==========================================

  /// Scales the widget vertically from small to normal while fading in.
  Widget animateScaleNFadeVertical({
    Duration duration = const Duration(milliseconds: 1000),
    Duration delay = Duration.zero,
    Alignment alignment = Alignment.center,
    bool isRepeat = true,
    VoidCallback? onComplete,
  }) {
    return animate(
        delay: delay,
        onPlay: isRepeat ? (controller) => controller.repeat(reverse: true) : null)
        .fadeIn(duration: 500.ms, curve: Curves.easeInOutQuart)
        .scaleY(
      alignment: alignment,
      begin: 0.5,
      end: 1,
      curve: Curves.easeInOutQuart,
      duration: duration,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Scales the widget horizontally from zero to normal while fading in.
  Widget animateScaleNFadeHorizontal({
    Duration duration = const Duration(milliseconds: 1000),
    Duration delay = Duration.zero,
    Alignment alignment = Alignment.center,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .fadeIn(duration: 500.ms, curve: Curves.easeInOutQuart)
        .scaleX(
      alignment: alignment,
      begin: 0.0,
      end: 1,
      curve: Curves.easeInOutQuart,
      duration: duration,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Zooms the widget in from 0% to 100% size with a bounce effect and fade.
  Widget animateZoomInStart({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    Alignment alignment = Alignment.center,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .scale(
      alignment: alignment,
      begin: const Offset(0.0, 0.0),
      end: const Offset(1.0, 1.0),
      duration: duration,
      curve: Curves.easeInOutBack,
    )
        .fadeIn(
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Shrinks the widget down to 0% and hides it.
  Widget animateZoomOutHide({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    bool maintain = false,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .scale(
      begin: const Offset(1, 1),
      end: const Offset(0.0, 0.0),
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .hide(
      maintain: maintain,
      delay: duration,
      duration: 300.ms,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  // ==========================================
  // Visibility & Blur Modifiers
  // ==========================================

  /// Completely hides the widget after the specified duration.
  Widget animateAfterDurationHide({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    bool maintain = false,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .hide(maintain: maintain, delay: duration)
        .callback(callback: (_) => onComplete?.call());
  }

  /// Makes the widget visible only after the specified duration.
  Widget animateAfterDurationVisibility({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    bool maintain = false,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .visibility(
      maintain: maintain,
      duration: duration,
    )
        .callback(callback: (_) => onComplete?.call());
  }

  /// Animates the widget from a blurred state into sharp focus.
  Widget animateBlur({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
    VoidCallback? onComplete,
  }) {
    return animate(delay: delay)
        .blur(
      end: const Offset(0, 0),
      begin: const Offset(2, 2),
      duration: duration,
      curve: Curves.easeInOutQuart,
    )
        .callback(callback: (_) => onComplete?.call());
  }
}

// =============================================================================
// Navigator Extensions
// =============================================================================

/// A set of extensions on [BuildContext] to simplify animated route transitions.
///
/// Instead of writing verbose `PageRouteBuilder` logic every time, you can now
/// simply call `context.pushSlideLeft(MyPage())`.
extension NavigatorAnimationExtension on BuildContext {

  /// Internal helper to manage whether to push a new route or replace the current one.
  Future _pushRoute(Route route, bool isReplacement) {
    if (isReplacement) {
      return Navigator.pushReplacement(this, route);
    }
    return Navigator.push(this, route);
  }

  /// Pushes a new page that slides in from the right to the left.
  Future pushSlideLeft(
      Widget page, {
        Duration duration = const Duration(milliseconds: 500),
        bool isReplacement = false,
      }) {
    final route = PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final offsetAnim = Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart));
        return SlideTransition(position: offsetAnim, child: child);
      },
    );

    return _pushRoute(route, isReplacement);
  }

  /// Pushes a new page that slides up from the bottom of the screen.
  Future pushSlideUp(
      Widget page, {
        Duration duration = const Duration(milliseconds: 500),
        bool isReplacement = false,
      }) {
    final route = PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final offsetAnim = Tween(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart));
        return SlideTransition(position: offsetAnim, child: child);
      },
    );

    return _pushRoute(route, isReplacement);
  }

  /// Pushes a new page using a smooth fade-in transition.
  Future pushFade(
      Widget page, {
        Duration duration = const Duration(milliseconds: 400),
        bool isReplacement = false,
      }) {
    final route = PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
          child: child,
        );
      },
    );

    return _pushRoute(route, isReplacement);
  }

  /// Pushes a new page that scales up (zooms slightly) into view.
  Future pushScale(
      Widget page, {
        Duration duration = const Duration(milliseconds: 500),
        bool isReplacement = false,
      }) {
    final route = PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final scaleAnim = Tween(begin: 0.8, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
        return ScaleTransition(scale: scaleAnim, child: child);
      },
    );

    return _pushRoute(route, isReplacement);
  }

  /// Pushes a new page using a spinning rotation transition.
  Future pushRotate(
      Widget page, {
        Duration duration = const Duration(milliseconds: 700),
        bool isReplacement = false,
      }) {
    final route = PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final rotateAnim = Tween(begin: -1.0, end: 0.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return RotationTransition(turns: rotateAnim, child: child);
      },
    );

    return _pushRoute(route, isReplacement);
  }

  /// Pushes a new page that zooms in from the center while fading in.
  Future pushZoomIn(
      Widget page, {
        Duration duration = const Duration(milliseconds: 500),
        bool isReplacement = false,
      }) {
    final route = PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final zoomAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ));

        final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

        return FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: zoomAnim,
            child: child,
          ),
        );
      },
    );

    return _pushRoute(route, isReplacement);
  }
}