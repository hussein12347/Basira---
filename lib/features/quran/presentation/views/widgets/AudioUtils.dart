import 'package:elda3ia_tour/features/quran/data/models/audio_model.dart';

/// A utility class for managing Quranic audio resources.
///
/// It provides helper methods to generate unique audio file codes and
/// construct remote streaming URLs based on reciter metadata and preferred bitrates.
class AudioUtils {

  /// Generates a standardized 6-digit audio code for a specific verse.
  ///
  /// The format is [SSS][VVV], where:
  /// - [SSS] is the 3-digit Surah number (e.g., 001 for Al-Fatihah).
  /// - [VVV] is the 3-digit Verse number (e.g., 007).
  /// Example: Surah 1, Verse 7 becomes '001007'.
  static String getAudioFileCode(int surahNumber, int verseNumber) {
    final surahStr = surahNumber.toString().padLeft(3, '0');
    final verseStr = verseNumber.toString().padLeft(3, '0');
    return '$surahStr$verseStr';
  }

  /// Constructs a streaming URL for a specific verse of a reciter.
  ///
  /// **Logic:** It prioritizes the highest available quality by checking
  /// bitrates in descending order (128kbps -> 64kbps -> 32kbps).
  /// Returns `null` if no valid URL is configured for the reciter.
  static String? getAudioUrl(AudioModel reciterModel, int surah, int verse) {
    final fileCode = getAudioFileCode(surah, verse);

    // Attempt to use 128kbps first for high quality
    if (reciterModel.audioUrlBitRate128 != null && reciterModel.audioUrlBitRate128!.isNotEmpty) {
      return '${reciterModel.audioUrlBitRate128}$fileCode.mp3';
    }
    // Fallback to 64kbps
    else if (reciterModel.audioUrlBitRate64 != null && reciterModel.audioUrlBitRate64!.isNotEmpty) {
      return '${reciterModel.audioUrlBitRate64}$fileCode.mp3';
    }
    // Fallback to 32kbps for low bandwidth
    else if (reciterModel.audioUrlBitRate32 != null && reciterModel.audioUrlBitRate32!.isNotEmpty) {
      return '${reciterModel.audioUrlBitRate32}$fileCode.mp3';
    }

    return null;
  }

  /// A static registry of all supported Quran reciters and their server endpoints.
  ///
  /// Each entry contains localized names, narration type (Rewaya),
  /// and available bitrate URLs.
  static List<Map<String, dynamic>> audios = [
    {
      "id": "0",
      "name_ar": "إبراهيم الأخضر",
      "name_en": "Ibrahim Al-Akhdar",
      "rewaya_ar": "حفص عن عاصم",
      "rewaya_en": "Hafs from Asim",
      "musshaf_type_ar": "مرتل",
      "musshaf_type_en": "Murattal",
      "audio_url_bit_rate_32": "https://verse.mp3quran.net/arabic/ibrahim_alakhdar/32/",
      "audio_url_bit_rate_64": "",
      "audio_url_bit_rate_128": "",
    },
    {
      "id": "1",
      "name_ar": "شيخ أبو بكر الشاطري",
      "name_en": "Sheikh Abu Bakr Al-Shatri",
      "rewaya_ar": "حفص عن عاصم",
      "rewaya_en": "Hafs from Asim",
      "musshaf_type_ar": "مرتل",
      "musshaf_type_en": "Murattal",
      "audio_url_bit_rate_32": "",
      "audio_url_bit_rate_64": "https://verse.mp3quran.net/arabic/shaik_abu_baker_alshatri/64/",
      "audio_url_bit_rate_128": "https://verse.mp3quran.net/arabic/shaik_abu_baker_alshatri/128/",
    },
    // ... rest of the reciters data
    {
      "id": "44",
      "name_ar": "نبيل الرفاعي",
      "name_en": "Nabil Ar Rifai",
      "rewaya_ar": "حفص عن عاصم",
      "rewaya_en": "Hafs from Asim",
      "musshaf_type_ar": "مرتل",
      "musshaf_type_en": "Murattal",
      "audio_url_bit_rate_32": "https://everyayah.com/data/Nabil_Rifa3i_48kbps/",
      "audio_url_bit_rate_64": "",
      "audio_url_bit_rate_128": "",
    },
  ];
}