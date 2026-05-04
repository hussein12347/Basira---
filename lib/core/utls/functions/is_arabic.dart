import 'package:intl/intl.dart';

/// A utility class for handling language, locale detection, and text analysis.
///
/// Provides helper methods to check the current app locale and identify
/// if a given string contains or is strictly composed of Arabic characters.
class LanguageHelper {
  // Private constructor to prevent instantiation of this utility class.
  LanguageHelper._();

  /// Checks if the app's current locale is set to Arabic.
  ///
  /// Returns `true` if the current locale string starts with 'ar'
  /// (e.g., 'ar', 'ar_EG', 'ar_SA').
  static bool isArabic() {
    final currentLocale = Intl.getCurrentLocale();
    return currentLocale.startsWith('ar');
  }

  /// Checks if the app's current locale is set to English.
  ///
  /// Returns `true` if the current locale string starts with 'en'
  /// (e.g., 'en', 'en_US', 'en_GB').
  static bool isEnglish() {
    final currentLocale = Intl.getCurrentLocale();
    return currentLocale.startsWith('en');
  }

  /// Checks if the given [text] contains *at least one* Arabic character.
  ///
  /// This is useful for determining text directionality (RTL vs LTR) when a
  /// string might contain a mix of Arabic and English.
  static bool isArabicText(String text) {
    if (text.isEmpty) return false;

    // Matches any character within the Arabic Unicode block
    final RegExp arabicRegex = RegExp(r'[\u0600-\u06FF]');

    return arabicRegex.hasMatch(text);
  }

  /// Checks if the given [text] consists *entirely* of Arabic characters,
  /// spaces, and common Arabic punctuation marks.
  ///
  /// Returns `false` if the text contains English letters, numbers, or
  /// symbols outside the specified regular expression.
  static bool isStrictlyArabicText(String text) {
    if (text.isEmpty) return false;

    // Matches strictly Arabic letters, spaces, and specific punctuation (، . ؟ !)
    final RegExp strictArabicRegex = RegExp(r'^[\u0600-\u06FF\s،.؟!]+$');
    return strictArabicRegex.hasMatch(text);
  }
}