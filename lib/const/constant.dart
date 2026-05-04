// ==========================================
// Routing Constants
// ==========================================

/// Route path for the favorite items screen.
const String kFavoriteRoute = '/favorite';

/// Route path for the application settings screen.
const String kSettingsRoute = '/settings';

/// Route path for the main home screen.
const String kHomeRoute = '/home';

/// Route path for the Quran reading page.
const String kQuranPageViewRoute = '/quranPageView';

/// Route path for the search functionality screen.
const String kSearchRoute = '/search';

/// Route path for the downloads management screen.
const String kDownloadsRoute = '/downloads';

// ==========================================
// Database Schema Constants (Bookmarks Table)
// ==========================================

/// The name of the bookmarks table in the local database.
const String kBookmarksTableName = 'bookmarks';

/// Database column name for storing the Surah (chapter) number.
const String kSurahNumberColumn = 'surah_number';

/// Database column name for storing the Verse (Ayah) number.
const String kVerseNumberColumn = 'verse_number';

/// Database column name for storing user notes associated with a bookmark.
const String kNoteColumn = 'note';

/// Database column name for the highlight color of the bookmark.
const String kColorColumn = 'color';

/// Database column name for the creation timestamp of the bookmark.
const String kCreatedAtColumn = 'created_at';