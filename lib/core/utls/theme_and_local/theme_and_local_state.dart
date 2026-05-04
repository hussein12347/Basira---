part of 'theme_and_local_cubit.dart';

/// Represents the state of the application's global preferences.
///
/// Marked as [@immutable] to ensure that state changes only occur
/// by creating new instances, which is a core principle of the Bloc/Cubit pattern.
@immutable
class ThemeAndLocalState {
  /// Indicates whether the app is currently in Dark Mode ([true]) or Light Mode ([false]).
  final bool isDark;

  /// The current language code of the application (e.g., 'en' for English, 'ar' for Arabic).
  final String locale;

  /// The string identifier of the currently active color theme (e.g., 'lightBlue', 'darkRed').
  final String theme;

  /// The font scaling multiplier used to calculate responsive text sizes across the app.
  final double fontScale;

  /// Constructs the state with default values.
  ///
  /// Defaults to Dark Mode, English locale, 'lightBlue' theme, and a standard font scale (1.0).
  const ThemeAndLocalState({
    this.isDark = true,
    this.locale = 'en',
    this.theme = 'lightBlue',
    this.fontScale = 1.0,
  });

  /// Creates a copy of the current state with optionally updated fields.
  ///
  /// This is essential for emitting new states in the Cubit while preserving
  /// the unmodified values from the previous state.
  ThemeAndLocalState copyWith({
    bool? isDark,
    String? locale,
    String? theme,
    double? fontScale,
  }) {
    return ThemeAndLocalState(
      isDark: isDark ?? this.isDark,
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}