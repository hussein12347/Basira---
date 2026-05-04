import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_and_local_state.dart';

/// A [Cubit] responsible for managing the application's global preferences.
///
/// This includes managing the brightness mode (Dark/Light), the specific
/// color theme, the selected language (Locale), and the font scale.
/// It uses [SharedPreferences] to persist these settings across app sessions.
class ThemeAndLocalCubit extends Cubit<ThemeAndLocalState> {
  ThemeAndLocalCubit() : super(const ThemeAndLocalState());

  /// A direct reference to the current font scale multiplier.
  ///
  /// Kept outside the state for quick synchronous reads without needing
  /// to access or listen to the emitted state.
  double fontScale = 1.0;

  /// Loads all saved preferences from local storage upon application startup.
  ///
  /// If no preferences are found, it defaults to Dark Mode, English locale,
  /// 'lightBlue' theme, and a font scale of 1.0.
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDark') ?? true;
    final locale = prefs.getString('locale') ?? 'en';
    final theme = prefs.getString('theme') ?? 'lightBlue';

    // Load the saved font scale or fallback to default (1.0)
    fontScale = prefs.getDouble('saved_font_scale') ?? 1.0;

    emit(ThemeAndLocalState(
      isDark: isDark,
      locale: locale,
      theme: theme,
      fontScale: fontScale,
    ));
  }

  // ==========================================
  // Preference Updaters
  // ==========================================

  /// Updates the application's font scale multiplier and saves it to local storage.
  ///
  /// [scale] is the new multiplier (e.g., 1.2 for 20% larger text).
  Future<void> changeFontScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saved_font_scale', scale);

    fontScale = scale; // Update the direct reference
    emit(state.copyWith(fontScale: scale));
  }

  /// Toggles the application's overall brightness between Dark and Light mode.
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = !state.isDark;

    await prefs.setBool('isDark', newTheme);
    emit(state.copyWith(isDark: newTheme));
  }

  /// Changes the application's locale (language) and persists the choice.
  ///
  /// [langCode] should be the standard language code (e.g., 'en', 'ar').
  Future<void> changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', langCode);

    emit(state.copyWith(locale: langCode));
  }

  /// Updates the specific color theme of the application.
  ///
  /// [theme] is the string identifier matching the themes defined in your AppThemes
  /// (e.g., 'lightBlue', 'darkRed').
  Future<void> changeTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);

    emit(state.copyWith(theme: theme));
  }
}