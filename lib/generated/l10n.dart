// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Choose Primary Color`
  String get choose_primary_color {
    return Intl.message(
      'Choose Primary Color',
      name: 'choose_primary_color',
      desc: '',
      args: [],
    );
  }

  /// `App Color`
  String get app_color {
    return Intl.message('App Color', name: 'app_color', desc: '', args: []);
  }

  /// `App Language`
  String get app_language {
    return Intl.message(
      'App Language',
      name: 'app_language',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message('Dark Mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `Appearance`
  String get appearance {
    return Intl.message('Appearance', name: 'appearance', desc: '', args: []);
  }

  /// `Font Scale`
  String get font_scale {
    return Intl.message('Font Scale', name: 'font_scale', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Quran`
  String get quran {
    return Intl.message('Quran', name: 'quran', desc: '', args: []);
  }

  /// `Last Read`
  String get lastRead {
    return Intl.message('Last Read', name: 'lastRead', desc: '', args: []);
  }

  /// `Page`
  String get page {
    return Intl.message('Page', name: 'page', desc: '', args: []);
  }

  /// `Surah`
  String get surah {
    return Intl.message('Surah', name: 'surah', desc: '', args: []);
  }

  /// `Juz`
  String get juz {
    return Intl.message('Juz', name: 'juz', desc: '', args: []);
  }

  /// `Verses`
  String get numberOfVerses {
    return Intl.message('Verses', name: 'numberOfVerses', desc: '', args: []);
  }

  /// `Hizb`
  String get hizb {
    return Intl.message('Hizb', name: 'hizb', desc: '', args: []);
  }

  /// `Play Recitation`
  String get play {
    return Intl.message('Play Recitation', name: 'play', desc: '', args: []);
  }

  /// `Copy Verse`
  String get copy {
    return Intl.message('Copy Verse', name: 'copy', desc: '', args: []);
  }

  /// `Verse`
  String get verse {
    return Intl.message('Verse', name: 'verse', desc: '', args: []);
  }

  /// `Copied to clipboard`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Verse`
  String get repeat_verse {
    return Intl.message(
      'Repeat Verse',
      name: 'repeat_verse',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `Disable Repeat`
  String get disable_repeat {
    return Intl.message(
      'Disable Repeat',
      name: 'disable_repeat',
      desc: '',
      args: [],
    );
  }

  /// `Search by page or surah`
  String get search_by_page_or_surah {
    return Intl.message(
      'Search by page or surah',
      name: 'search_by_page_or_surah',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get no_results_found {
    return Intl.message(
      'No results found',
      name: 'no_results_found',
      desc: '',
      args: [],
    );
  }

  /// `Starts from surah`
  String get starts_from_surah {
    return Intl.message(
      'Starts from surah',
      name: 'starts_from_surah',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Quran Display Mode`
  String get quran_display_mode {
    return Intl.message(
      'Quran Display Mode',
      name: 'quran_display_mode',
      desc: '',
      args: [],
    );
  }

  /// `Mushaf Display Mode(page by page)`
  String get mushaf_display_mode {
    return Intl.message(
      'Mushaf Display Mode(page by page)',
      name: 'mushaf_display_mode',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `List display mode`
  String get List_display_mode {
    return Intl.message(
      'List display mode',
      name: 'List_display_mode',
      desc: '',
      args: [],
    );
  }

  /// `Search in Quran`
  String get searchInQuran {
    return Intl.message(
      'Search in Quran',
      name: 'searchInQuran',
      desc: '',
      args: [],
    );
  }

  /// `Search for a word or Ayah (e.g., Al-Rahman)...`
  String get searchHintText {
    return Intl.message(
      'Search for a word or Ayah (e.g., Al-Rahman)...',
      name: 'searchHintText',
      desc: '',
      args: [],
    );
  }

  /// `Type a word to search in the verses of the Holy Quran`
  String get searchEmptyText {
    return Intl.message(
      'Type a word to search in the verses of the Holy Quran',
      name: 'searchEmptyText',
      desc: '',
      args: [],
    );
  }

  /// `No results found for`
  String get noResultsFor {
    return Intl.message(
      'No results found for',
      name: 'noResultsFor',
      desc: '',
      args: [],
    );
  }

  /// `Found`
  String get foundResults {
    return Intl.message('Found', name: 'foundResults', desc: '', args: []);
  }

  /// `results`
  String get resultsCount {
    return Intl.message('results', name: 'resultsCount', desc: '', args: []);
  }

  /// `Go to Ayah`
  String get goToAyah {
    return Intl.message('Go to Ayah', name: 'goToAyah', desc: '', args: []);
  }

  /// `Downloads Manager`
  String get downloads_manager {
    return Intl.message(
      'Downloads Manager',
      name: 'downloads_manager',
      desc: '',
      args: [],
    );
  }

  /// `Search for reciter...`
  String get search_reciter {
    return Intl.message(
      'Search for reciter...',
      name: 'search_reciter',
      desc: '',
      args: [],
    );
  }

  /// `No reciter found with this name`
  String get no_reciter_found {
    return Intl.message(
      'No reciter found with this name',
      name: 'no_reciter_found',
      desc: '',
      args: [],
    );
  }

  /// `Batch Download`
  String get batch_download {
    return Intl.message(
      'Batch Download',
      name: 'batch_download',
      desc: '',
      args: [],
    );
  }

  /// `Select the range of Surahs you want to download at once`
  String get batch_download_desc {
    return Intl.message(
      'Select the range of Surahs you want to download at once',
      name: 'batch_download_desc',
      desc: '',
      args: [],
    );
  }

  /// `From Surah`
  String get from_surah {
    return Intl.message('From Surah', name: 'from_surah', desc: '', args: []);
  }

  /// `To Surah`
  String get to_surah {
    return Intl.message('To Surah', name: 'to_surah', desc: '', args: []);
  }

  /// `Start Download`
  String get start_download {
    return Intl.message(
      'Start Download',
      name: 'start_download',
      desc: '',
      args: [],
    );
  }

  /// `Multi Download`
  String get multi_download {
    return Intl.message(
      'Multi Download',
      name: 'multi_download',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded successfully`
  String get download_success {
    return Intl.message(
      'Downloaded successfully',
      name: 'download_success',
      desc: '',
      args: [],
    );
  }

  /// `Verses`
  String get verses {
    return Intl.message('Verses', name: 'verses', desc: '', args: []);
  }

  /// `Ayah`
  String get ayah {
    return Intl.message('Ayah', name: 'ayah', desc: '', args: []);
  }

  /// `Revelation`
  String get revelation {
    return Intl.message('Revelation', name: 'revelation', desc: '', args: []);
  }

  /// `Meccan`
  String get revelation_makki {
    return Intl.message('Meccan', name: 'revelation_makki', desc: '', args: []);
  }

  /// `Medinan`
  String get revelation_madani {
    return Intl.message(
      'Medinan',
      name: 'revelation_madani',
      desc: '',
      args: [],
    );
  }

  /// `Quarter`
  String get quarter {
    return Intl.message('Quarter', name: 'quarter', desc: '', args: []);
  }

  /// `Tafsir Al-Muyassar`
  String get tafsir_moyser {
    return Intl.message(
      'Tafsir Al-Muyassar',
      name: 'tafsir_moyser',
      desc: '',
      args: [],
    );
  }

  /// `Mokhtasar Tafsir (English)`
  String get tafsir_english {
    return Intl.message(
      'Mokhtasar Tafsir (English)',
      name: 'tafsir_english',
      desc: '',
      args: [],
    );
  }

  /// `English Translation`
  String get english_translation {
    return Intl.message(
      'English Translation',
      name: 'english_translation',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copied_to_clipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Verse bookmarked successfully`
  String get bookmark_saved {
    return Intl.message(
      'Verse bookmarked successfully',
      name: 'bookmark_saved',
      desc: '',
      args: [],
    );
  }

  /// `Verse Info`
  String get ayah_info {
    return Intl.message('Verse Info', name: 'ayah_info', desc: '', args: []);
  }

  /// `Save Bookmark`
  String get save_bookmark {
    return Intl.message(
      'Save Bookmark',
      name: 'save_bookmark',
      desc: '',
      args: [],
    );
  }

  /// `Copy Verse`
  String get copy_ayah {
    return Intl.message('Copy Verse', name: 'copy_ayah', desc: '', args: []);
  }

  /// `Pause`
  String get pause {
    return Intl.message('Pause', name: 'pause', desc: '', args: []);
  }

  /// `Play this verse only`
  String get play_single_verse {
    return Intl.message(
      'Play this verse only',
      name: 'play_single_verse',
      desc: '',
      args: [],
    );
  }

  /// `Play to end of Surah`
  String get play_to_end_of_surah {
    return Intl.message(
      'Play to end of Surah',
      name: 'play_to_end_of_surah',
      desc: '',
      args: [],
    );
  }

  /// `Play full Quran`
  String get play_full_quran {
    return Intl.message(
      'Play full Quran',
      name: 'play_full_quran',
      desc: '',
      args: [],
    );
  }

  /// `Copy Verse`
  String get copy_verse {
    return Intl.message('Copy Verse', name: 'copy_verse', desc: '', args: []);
  }

  /// `Tafsir & Translation`
  String get tafsir_and_translation {
    return Intl.message(
      'Tafsir & Translation',
      name: 'tafsir_and_translation',
      desc: '',
      args: [],
    );
  }

  /// `Play custom range`
  String get play_custom_range {
    return Intl.message(
      'Play custom range',
      name: 'play_custom_range',
      desc: '',
      args: [],
    );
  }

  /// `From (Start):`
  String get from_start {
    return Intl.message(
      'From (Start):',
      name: 'from_start',
      desc: '',
      args: [],
    );
  }

  /// `To (End):`
  String get to_end {
    return Intl.message('To (End):', name: 'to_end', desc: '', args: []);
  }

  /// `Start Recitation`
  String get start_recitation {
    return Intl.message(
      'Start Recitation',
      name: 'start_recitation',
      desc: '',
      args: [],
    );
  }

  /// `Save as Bookmark`
  String get save_bookmark_title {
    return Intl.message(
      'Save as Bookmark',
      name: 'save_bookmark_title',
      desc: '',
      args: [],
    );
  }

  /// `Add a note (Optional)`
  String get add_note_optional {
    return Intl.message(
      'Add a note (Optional)',
      name: 'add_note_optional',
      desc: '',
      args: [],
    );
  }

  /// `Choose bookmark color:`
  String get choose_bookmark_color {
    return Intl.message(
      'Choose bookmark color:',
      name: 'choose_bookmark_color',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark saved successfully!`
  String get bookmark_saved_successfully {
    return Intl.message(
      'Bookmark saved successfully!',
      name: 'bookmark_saved_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Save Bookmark`
  String get save_bookmark_button {
    return Intl.message(
      'Save Bookmark',
      name: 'save_bookmark_button',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get bookmarks {
    return Intl.message('Bookmarks', name: 'bookmarks', desc: '', args: []);
  }

  /// `No saved bookmarks found`
  String get no_bookmarks {
    return Intl.message(
      'No saved bookmarks found',
      name: 'no_bookmarks',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noData {
    return Intl.message(
      'No data available',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Delete Bookmark`
  String get delete_bookmark {
    return Intl.message(
      'Delete Bookmark',
      name: 'delete_bookmark',
      desc: '',
      args: [],
    );
  }

  /// `Remove Bookmark`
  String get remove_bookmark {
    return Intl.message(
      'Remove Bookmark',
      name: 'remove_bookmark',
      desc: '',
      args: [],
    );
  }

  /// `Save Bookmark`
  String get add_bookmark {
    return Intl.message(
      'Save Bookmark',
      name: 'add_bookmark',
      desc: '',
      args: [],
    );
  }

  /// `View Note`
  String get view_note {
    return Intl.message('View Note', name: 'view_note', desc: '', args: []);
  }

  /// `Bookmark removed successfully`
  String get bookmark_removed {
    return Intl.message(
      'Bookmark removed successfully',
      name: 'bookmark_removed',
      desc: '',
      args: [],
    );
  }

  /// `Your Note`
  String get your_note {
    return Intl.message('Your Note', name: 'your_note', desc: '', args: []);
  }

  /// `Go to Page`
  String get goToPage {
    return Intl.message('Go to Page', name: 'goToPage', desc: '', args: []);
  }

  /// `Enter page number`
  String get enterPageNumber {
    return Intl.message(
      'Enter page number',
      name: 'enterPageNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid page (1-604)`
  String get invalidPage {
    return Intl.message(
      'Please enter a valid page (1-604)',
      name: 'invalidPage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
