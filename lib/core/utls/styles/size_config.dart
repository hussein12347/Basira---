import 'package:flutter/material.dart';

/// A utility class for managing responsive layout breakpoints and screen dimensions.
///
/// This class provides standardized breakpoints for tablet and desktop screens,
/// and caches the current screen's width and height for easy access without
/// repeatedly calling [MediaQuery].
class SizeConfig {
  // Private constructor to prevent instantiation of this utility class.
  SizeConfig._();

  /// The minimum width (in logical pixels) for a screen to be considered a desktop.
  static const double desktop = 1200;

  /// The minimum width (in logical pixels) for a screen to be considered a tablet.
  static const double tablet = 800;

  /// The cached width of the device screen.
  ///
  /// Must be initialized by calling [init] before use.
  static late double width;

  /// The cached height of the device screen.
  ///
  /// Must be initialized by calling [init] before use.
  static late double height;

  /// Initializes or updates the screen dimensions using the provided [context].
  ///
  /// This should typically be called in the `build` method of your root
  /// responsive widget or whenever the screen size might change
  /// (e.g., orientation changes).
  static void init(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
  }
}