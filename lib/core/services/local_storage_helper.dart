import 'package:shared_preferences/shared_preferences.dart';

/// A utility class to manage local storage using [SharedPreferences].
///
/// Handles saving and retrieving user preferences such as reading progress,
/// font scaling, and reading modes.
class LocalStorageHelper {
  // Private constructor to prevent instantiation.
  LocalStorageHelper._();

  // ==========================================
  // Storage Keys
  // ==========================================
  static const String _fontScaleKey = 'saved_font_scale';
  static const String _lastPageKey = 'last_page';
  static const String _lastSurahKey = 'last_surah';
  static const String _lastAyahKey = 'last_ayah';
  static const String _copyStyleKey = 'copyStyle';
  static const String _lastReciterId = 'last_reciter_id';
  static const String _isMushafModeKey = 'is_mushaf_mode';

  static const double _defaultFontScale = 1.0;

  // ==========================================
  // Font Scale Settings
  // ==========================================

  /// Retrieves the saved font scale multiplier.
  ///
  /// Returns the default scale (1.0) if no custom scale is saved.
  static Future<double> getFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontScaleKey) ?? _defaultFontScale;
  }

  /// Saves the user's preferred font scale multiplier.
  static Future<void> saveFontScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontScaleKey, scale);
  }

  // ==========================================
  // Copy Style Settings
  // ==========================================

  /// Saves the user's preferred copy style.
  ///
  /// [isCollection] indicates whether the user prefers copying as a collection.
  static Future<void> saveCopyStyle(bool isCollection) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_copyStyleKey, isCollection);
  }

  /// Retrieves the saved copy style preference.
  ///
  /// Returns `true` (collection style) by default if not previously saved.
  static Future<bool> getCopyStyle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_copyStyleKey) ?? true;
  }

  // ==========================================
  // Reading Progress (Page, Surah, Ayah)
  // ==========================================

  /// Saves the last read page number.
  static Future<void> saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPageKey, page);
  }

  /// Retrieves the last read page number. Defaults to 1.
  static Future<int> getLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastPageKey) ?? 1;
  }

  /// Saves the last read Surah (chapter) number.
  static Future<void> saveLastSurah(int surah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSurahKey, surah);
  }

  /// Retrieves the last read Surah (chapter) number. Defaults to 1.
  static Future<int> getLastSurah() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastSurahKey) ?? 1;
  }

  /// Saves the last read Ayah (verse) number.
  static Future<void> saveLastAyah(int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastAyahKey, ayah);
  }

  /// Retrieves the last read Ayah (verse) number.
  ///
  /// Returns `null` if no Ayah progress was previously saved.
  static Future<int?> getLastAyah() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastAyahKey);
  }

  // ==========================================
  // Audio Reciter Settings
  // ==========================================

  /// Saves the ID of the last selected audio reciter.
  static Future<void> saveLastReciter(String reciterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReciterId, reciterId);
  }

  /// Retrieves the ID of the last selected audio reciter.
  static Future<String?> getLastReciterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastReciterId);
  }

  // ==========================================
  // Mushaf Mode Settings
  // ==========================================

  /// Saves the user's preference for the reading mode (Mushaf mode).
  static Future<void> saveIsMushafMode(bool isMushaf) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isMushafModeKey, isMushaf);
  }

  /// Retrieves the Mushaf reading mode preference.
  ///
  /// Returns `true` by default if not previously saved.
  static Future<bool> getIsMushafMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isMushafModeKey) ?? true;
  }
}