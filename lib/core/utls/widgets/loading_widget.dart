import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A global utility function that returns the standard loading animation
/// used throughout the application.
///
/// It uses the `loading_animation_widget` package to display an 'inkDrop'
/// animation. The color is automatically adapted to the current theme's
/// secondary color to ensure visual consistency in both Light and Dark modes.
///
/// **Usage:**
/// ```dart
/// Center(
///   child: kLoadingWidget(context),
/// )
/// ```
Widget kLoadingWidget(BuildContext context) {
  return LoadingAnimationWidget.inkDrop(
    color: Theme.of(context).colorScheme.secondary,
    size: 50,
  );
}