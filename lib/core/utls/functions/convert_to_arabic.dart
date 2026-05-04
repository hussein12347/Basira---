/// A utility class for converting standard Western Arabic numerals (0-9)
/// into Eastern Arabic numerals (٠-٩).
class ConvertToArabic {
  // Private constructor to prevent instantiation of this utility class.
  ConvertToArabic._();

  /// Converts an integer [number] into a string formatted with Eastern Arabic numerals.
  ///
  /// This is particularly useful for localizing UI elements in Arabic applications
  /// (e.g., displaying Ayah numbers, page numbers, or statistics).
  ///
  /// **Example:**
  /// ```dart
  /// String result = ConvertToArabic.convertToArabicNumber(123);
  /// print(result); // Outputs: ١٢٣
  /// ```
  static String convertToArabicNumber(int number) {
    const Map<String, String> arabicNumbers = {
      "0": "٠",
      "1": "١",
      "2": "٢",
      "3": "٣",
      "4": "٤",
      "5": "٥",
      "6": "٦",
      "7": "٧",
      "8": "٨",
      "9": "٩",
    };

    return number
        .toString()
        .split('')
        .map((e) => arabicNumbers[e] ?? e)
        .join('');
  }
}