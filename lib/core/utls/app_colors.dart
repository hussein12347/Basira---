// lib/core/style/colors.dart
import 'package:flutter/material.dart';

/// A centralized class containing all the fixed colors used across the application.
///
/// Using this class ensures a consistent color palette and makes it easy to
/// update the app's branding from a single place.
class AppColors {
  // Private constructor to prevent instantiation.
  AppColors._();

  // ==========================================
  // Brand / Core Colors
  // ==========================================

  /// The main brand color, used for primary buttons, active states, and key UI elements.
  static const Color primary = Color(0xFF4361EE);

  /// A secondary brand color, often used to complement the primary color.
  static const Color secondary = Color(0xFF3A0CA3);

  /// Used for highlighting specific UI elements, floating action buttons, or active tabs.
  static const Color accent = Color(0xFF7209B7);

  // ==========================================
  // Semantic / Status Colors
  // ==========================================

  /// Used to indicate successful actions (e.g., success snackbars, checkmarks).
  static const Color success = Color(0xFF4CAF50);

  /// Used to indicate errors, destructive actions, or critical alerts.
  static const Color error = Color(0xFFF44336);

  /// Used to indicate warnings or processes that need the user's attention.
  static const Color warning = Color(0xFFFF9800);

  // ==========================================
  // Background & Surface Colors
  // ==========================================

  /// The default background color for scaffolds and main screens.
  static const Color background = Color(0xFFF8F9FA);

  /// Used for the background of cards, dialogs, and elevated surfaces.
  static const Color card = Color(0xFFFFFFFF);

  // ==========================================
  // Typography / Text Colors
  // ==========================================

  /// The primary text color for high emphasis content (e.g., headings, main body).
  static const Color darkText = Color(0xFF212121);

  /// A secondary text color for medium emphasis content (e.g., subtitles, hints).
  static const Color lightText = Color(0xFF757575);

  /// Pure white, typically used for text on top of dark or primary colored backgrounds.
  static const Color white = Color(0xFFFFFFFF);

  // ==========================================
  // Utility / Misc Colors
  // ==========================================

  /// Used for generating drop shadows behind elevated UI elements.
  static const Color shadow = Color(0xFF000000);

  /// Used for disabled states, borders, or subtle dividers.
  static const Color lightGrey = Color(0xFFE0E0E0);

  /// A soft red variant, often used as a background for error containers or soft alerts.
  static const Color lightRed = Color(0xFFFFEBEE);
}