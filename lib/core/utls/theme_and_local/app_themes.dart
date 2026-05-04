import 'package:flutter/material.dart';

/// A comprehensive theme manager for the application.
///
/// Provides a wide variety of pre-configured Light and Dark themes.
/// It centralizes the styling for all UI components (AppBars, Buttons, Inputs, etc.)
/// ensuring a consistent look and feel across the entire app.
class AppThemes {
  // Private constructor to prevent instantiation.
  AppThemes._();

  // ===========================================================================
  // Full Light Themes
  // ===========================================================================

  static ThemeData get lightRed => _createLightTheme(
    name: 'red',
    primary: const Color(0xFFD32F2F),
    secondary: const Color(0xFFEF5350),
    primaryVariant: const Color(0xFFB71C1C),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF311313),
  );

  static ThemeData get lightPink => _createLightTheme(
    name: 'pink',
    primary: const Color(0xFFC2185B),
    secondary: const Color(0xFFEC407A),
    primaryVariant: const Color(0xFF880E4F),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF31131E),
  );

  static ThemeData get lightPurple => _createLightTheme(
    name: 'purple',
    primary: const Color(0xFF6A1B9A),
    secondary: const Color(0xFF9C27B0),
    primaryVariant: const Color(0xFF4A148C),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF2D1B3D),
  );

  static ThemeData get lightDeepPurple => _createLightTheme(
    name: 'purple deep',
    primary: const Color(0xFF4527A0),
    secondary: const Color(0xFF673AB7),
    primaryVariant: const Color(0xFF311B92),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF221842),
  );

  static ThemeData get lightIndigo => _createLightTheme(
    name: 'indigo',
    primary: const Color(0xFF283593),
    secondary: const Color(0xFF3F51B5),
    primaryVariant: const Color(0xFF1A237E),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF1C1F33),
  );

  static ThemeData get lightBlue => _createLightTheme(
    name: 'blue',
    primary: const Color(0xFF1565C0),
    secondary: const Color(0xFF2196F3),
    primaryVariant: const Color(0xFF0D47A1),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF18273C),
  );

  static ThemeData get lightLightBlue => _createLightTheme(
    name: 'blue light',
    primary: const Color(0xFF0277BD),
    secondary: const Color(0xFF03A9F4),
    primaryVariant: const Color(0xFF01579B),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF152A37),
  );

  static ThemeData get lightCyan => _createLightTheme(
    name: 'cyan',
    primary: const Color(0xFF00838F),
    secondary: const Color(0xFF00BCD4),
    primaryVariant: const Color(0xFF006064),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF152D30),
  );

  static ThemeData get lightTeal => _createLightTheme(
    name: 'teal',
    primary: const Color(0xFF00695C),
    secondary: const Color(0xFF009688),
    primaryVariant: const Color(0xFF004D40),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF152C29),
  );

  static ThemeData get lightGreen => _createLightTheme(
    name: 'green',
    primary: const Color(0xFF2E7D32),
    secondary: const Color(0xFF4CAF50),
    primaryVariant: const Color(0xFF1B5E20),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF1C2A1D),
  );

  static ThemeData get lightLightGreen => _createLightTheme(
    name: 'green light',
    primary: const Color(0xFF558B2F),
    secondary: const Color(0xFF7CB342),
    primaryVariant: const Color(0xFF33691E),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF232D1B),
  );

  static ThemeData get lightLime => _createLightTheme(
    name: 'lime',
    primary: const Color(0xFF9E9D24),
    secondary: const Color(0xFFCDDC39),
    primaryVariant: const Color(0xFF827717),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF2E2E1E),
    onPrimary: Colors.black, // Black text on yellow background
  );

  static ThemeData get lightYellow => _createLightTheme(
    name: 'yello',
    primary: const Color(0xFFF9A825),
    secondary: const Color(0xFFFFEB3B),
    primaryVariant: const Color(0xFFF57F17),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF332B14),
    onPrimary: Colors.black, // Black text on yellow background
  );

  static ThemeData get lightAmber => _createLightTheme(
    name: 'amber',
    primary: const Color(0xFFFF8F00),
    secondary: const Color(0xFFFFC107),
    primaryVariant: const Color(0xFFFF6F00),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF332715),
    onPrimary: Colors.black, // Black text on orange background
  );

  static ThemeData get lightOrange => _createLightTheme(
    name: 'orange',
    primary: const Color(0xFFEF6C00),
    secondary: const Color(0xFFFF9800),
    primaryVariant: const Color(0xFFE65100),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF312215),
    onPrimary:  const Color(0xfffbf2e6), // White text on dark orange background
  );

  static ThemeData get lightDeepOrange => _createLightTheme(
    name: 'orange deep',
    primary: const Color(0xFFD84315),
    secondary: const Color(0xFFFF5722),
    primaryVariant: const Color(0xFFBF360C),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF2E1C15),
    onPrimary:  const Color(0xfffbf2e6), // White text on dark orange background
  );

  static ThemeData get lightBrown => _createLightTheme(
    name: 'brown',
    primary: const Color(0xFF5D4037),
    secondary: const Color(0xFF795548),
    primaryVariant: const Color(0xFF3E2723),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF241C1A),
    onPrimary:  const Color(0xfffbf2e6), // White text on brown background
  );

  static ThemeData get lightGrey => _createLightTheme(
    name: 'grey',
    primary: const Color(0xFF616161),
    secondary: const Color(0xFF9E9E9E),
    primaryVariant: const Color(0xFF424242),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF212121),
    onPrimary:  const Color(0xfffbf2e6), // White text on dark grey background
  );

  static ThemeData get lightBlueGrey => _createLightTheme(
    name: 'blue grey',
    primary: const Color(0xFF37474F),
    secondary: const Color(0xFF607D8B),
    primaryVariant: const Color(0xFF263238),
    surface:  const Color(0xfffbf2e6),
    background: const Color(0xfffbf2e6),
    onBackground: const Color(0xFF1A2327),
    onPrimary:  const Color(0xfffbf2e6), // White text on blue-grey background
  );

  // ===========================================================================
  // Full Dark Themes
  // ===========================================================================

  static ThemeData get darkRed => _createDarkTheme(
    name: 'red dark',
    primary: const Color(0xFFEF9A9A),
    secondary: const Color(0xFFE57373),
    primaryVariant: const Color(0xFFD32F2F),
    surface: const Color(0xFF1A1212),
    background: const Color(0xFF120C0C),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light red
    onSecondary: Colors.black, // Black text on light red
  );

  static ThemeData get darkPink => _createDarkTheme(
    name: 'pink dark',
    primary: const Color(0xFFF48FB1),
    secondary: const Color(0xFFF06292),
    primaryVariant: const Color(0xFFC2185B),
    surface: const Color(0xFF1A1215),
    background: const Color(0xFF120C0F),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light pink
    onSecondary: Colors.black, // Black text on light pink
  );

  static ThemeData get darkPurple => _createDarkTheme(
    name: 'purple dark',
    primary: const Color(0xFFCE93D8),
    secondary: const Color(0xFFBA68C8),
    primaryVariant: const Color(0xFF6A1B9A),
    surface: const Color(0xFF1A121D),
    background: const Color(0xFF120C17),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light purple
    onSecondary: Colors.black, // Black text on light purple
  );

  static ThemeData get darkDeepPurple => _createDarkTheme(
    name: 'purple deep dark',
    primary: const Color(0xFFB39DDB),
    secondary: const Color(0xFF9575CD),
    primaryVariant: const Color(0xFF4527A0),
    surface: const Color(0xFF14121D),
    background: const Color(0xFF0E0C17),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light purple
    onSecondary: Colors.black, // Black text on light purple
  );

  static ThemeData get darkIndigo => _createDarkTheme(
    name: 'indigo dark',
    primary: const Color(0xFF9FA8DA),
    secondary: const Color(0xFF7986CB),
    primaryVariant: const Color(0xFF283593),
    surface: const Color(0xFF12131D),
    background: const Color(0xFF0C0D17),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light indigo
    onSecondary: Colors.black, // Black text on light indigo
  );

  static ThemeData get darkBlue => _createDarkTheme(
    name: 'blue dark',
    primary: const Color(0xFF90CAF9),
    secondary: const Color(0xFF64B5F6),
    primaryVariant: const Color(0xFF1565C0),
    surface: const Color(0xFF121826),
    background: const Color(0xFF0A0E17),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light blue
    onSecondary: Colors.black, // Black text on light blue
  );

  static ThemeData get darkLightBlue => _createDarkTheme(
    name: 'blue light dark',
    primary: const Color(0xFF81D4FA),
    secondary: const Color(0xFF4FC3F7),
    primaryVariant: const Color(0xFF0277BD),
    surface: const Color(0xFF0F1A26),
    background: const Color(0xFF09121A),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light blue
    onSecondary: Colors.black, // Black text on light blue
  );

  static ThemeData get darkCyan => _createDarkTheme(
    name: 'cyan dark',
    primary: const Color(0xFF80DEEA),
    secondary: const Color(0xFF4DD0E1),
    primaryVariant: const Color(0xFF00838F),
    surface: const Color(0xFF0D1A26),
    background: const Color(0xFF08111A),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light cyan
    onSecondary: Colors.black, // Black text on light cyan
  );

  static ThemeData get darkTeal => _createDarkTheme(
    name: 'teal dark',
    primary: const Color(0xFF80CBC4),
    secondary: const Color(0xFF4DB6AC),
    primaryVariant: const Color(0xFF00695C),
    surface: const Color(0xFF0D1A18),
    background: const Color(0xFF081110),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light teal
    onSecondary: Colors.black, // Black text on light teal
  );

  static ThemeData get darkGreen => _createDarkTheme(
    name: 'green dark',
    primary: const Color(0xFFA5D6A7),
    secondary: const Color(0xFF81C784),
    primaryVariant: const Color(0xFF2E7D32),
    surface: const Color(0xFF0D1A0D),
    background: const Color(0xFF081008),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light green
    onSecondary: Colors.black, // Black text on light green
  );

  static ThemeData get darkLightGreen => _createDarkTheme(
    name: 'green light dark',
    primary: const Color(0xFFC5E1A5),
    secondary: const Color(0xFFAED581),
    primaryVariant: const Color(0xFF558B2F),
    surface: const Color(0xFF111A0D),
    background: const Color(0xFF0B1208),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light green
    onSecondary: Colors.black, // Black text on light green
  );

  static ThemeData get darkLime => _createDarkTheme(
    name: 'lime dark',
    primary: const Color(0xFFE6EE9C),
    secondary: const Color(0xFFDCE775),
    primaryVariant: const Color(0xFF9E9D24),
    surface: const Color(0xFF1A1A0D),
    background: const Color(0xFF121208),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light lime
    onSecondary: Colors.black, // Black text on light lime
  );

  static ThemeData get darkYellow => _createDarkTheme(
    name: 'yellow dark',
    primary: const Color(0xFFFFF59D),
    secondary: const Color(0xFFFFF176),
    primaryVariant: const Color(0xFFF9A825),
    surface: const Color(0xFF1A180D),
    background: const Color(0xFF121008),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light yellow
    onSecondary: Colors.black, // Black text on light yellow
  );

  static ThemeData get darkAmber => _createDarkTheme(
    name: 'amber dark',
    primary: const Color(0xFFFFE082),
    secondary: const Color(0xFFFFD54F),
    primaryVariant: const Color(0xFFFF8F00),
    surface: const Color(0xFF1A160D),
    background: const Color(0xFF120E08),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light amber
    onSecondary: Colors.black, // Black text on light amber
  );

  static ThemeData get darkOrange => _createDarkTheme(
    name: 'orange dark',
    primary: const Color(0xFFFFCC80),
    secondary: const Color(0xFFFFB74D),
    primaryVariant: const Color(0xFFEF6C00),
    surface: const Color(0xFF1A150D),
    background: const Color(0xFF120D08),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light orange
    onSecondary: Colors.black, // Black text on light orange
  );

  static ThemeData get darkDeepOrange => _createDarkTheme(
    name: 'orange deep dark',
    primary: const Color(0xFFFFAB91),
    secondary: const Color(0xFFFF8A65),
    primaryVariant: const Color(0xFFD84315),
    surface: const Color(0xFF1A130D),
    background: const Color(0xFF120B08),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light orange
    onSecondary: Colors.black, // Black text on light orange
  );

  static ThemeData get darkBrown => _createDarkTheme(
    name: 'brown dark',
    primary: const Color(0xFFBCAAA4),
    secondary: const Color(0xFFA1887F),
    primaryVariant: const Color(0xFF5D4037),
    surface: const Color(0xFF1A1615),
    background: const Color(0xFF120F0E),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light brown
    onSecondary: Colors.black, // Black text on light brown
  );

  static ThemeData get darkGrey => _createDarkTheme(
    name: 'grey dark',
    primary: const Color(0xFFE0E0E0),
    secondary: const Color(0xFFBDBDBD),
    primaryVariant: const Color(0xFF616161),
    surface: const Color(0xFF1A1A1A),
    background: const Color(0xFF121212),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light grey
    onSecondary: Colors.black, // Black text on light grey
  );

  static ThemeData get darkBlueGrey => _createDarkTheme(
    name: 'blue grey dark',
    primary: const Color(0xFFB0BEC5),
    secondary: const Color(0xFF90A4AE),
    primaryVariant: const Color(0xFF37474F),
    surface: const Color(0xFF12171A),
    background: const Color(0xFF0C1013),
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light blue-grey
    onSecondary: Colors.black, // Black text on light blue-grey
  );

  static ThemeData get darkAmoled => _createDarkTheme(
    name: 'black deep',
    primary: const Color(0xFF00838F),
    secondary: const Color(0xFF03DAC6),
    primaryVariant: const Color(0xFF006064),
    surface: Colors.black,
    background: Colors.black,
    onBackground:  const Color(0xfffbf2e6),
    onPrimary: Colors.black, // Black text on light purple
    onSecondary: Colors.black, // Black text on light teal
    brightness: Brightness.dark,
    elevation: 0.0,
  );

  // ===========================================================================
  // Helper Methods for Theme Generation
  // ===========================================================================

  /// Centralized method to generate a light [ThemeData] configuration.
  static ThemeData _createLightTheme({
    required String name,
    required Color primary,
    required Color secondary,
    required Color primaryVariant,
    required Color surface,
    required Color background,
    required Color onBackground,
    Color? onPrimary,
    Color? onSecondary,
  }) {
    return ThemeData.light().copyWith(
      // === Basic Parameters ===
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      cardColor: surface,
      disabledColor: onBackground.withOpacity(0.38),

      // === Custom Theme Extension ===
      extensions: <ThemeExtension<dynamic>>[
        AppThemeInfo(name: name),
      ],

      // === AppBar ===
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onBackground,
        elevation: 1,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onBackground,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(
          color: onBackground.withOpacity(0.8),
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: onBackground.withOpacity(0.8),
          size: 24,
        ),
      ),

      // === ColorScheme ===
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: onPrimary ??  const Color(0xfffbf2e6),
        onSecondary: onSecondary ??  const Color(0xfffbf2e6),
        onSurface: onBackground,
        primaryContainer: primary.withOpacity(0.12),
        secondaryContainer: secondary.withOpacity(0.12),
        error: const Color(0xFFD32F2F),
        onError:  const Color(0xfffbf2e6),
      ).copyWith(
        primaryContainer: primaryVariant,
      ),

      // === Typography ===
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: onBackground,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onBackground,
          letterSpacing: -0.3,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onBackground,
          letterSpacing: -0.2,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onBackground.withOpacity(0.87),
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onBackground.withOpacity(0.6),
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onBackground.withOpacity(0.6),
        ),
      ),

      // === Buttons ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary ??  const Color(0xfffbf2e6),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: primary.withOpacity(0.3)),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // === Bottom Navigation Bar ===
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onBackground.withOpacity(0.5),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),

      // === Input Fields ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: onBackground.withOpacity(0.04),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: onBackground.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onBackground.withOpacity(0.4),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onBackground.withOpacity(0.6),
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      // === Icons ===
      iconTheme: IconThemeData(
        color: onBackground.withOpacity(0.8),
        size: 24,
      ),

      // === Cards ===
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // === Dividers ===
      dividerTheme: DividerThemeData(
        color: onBackground.withOpacity(0.12),
        thickness: 1,
        space: 0,
      ),

      // === Data Tables ===
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(
          onBackground.withOpacity(0.04),
        ),
        dataRowColor: WidgetStatePropertyAll(Colors.transparent),
        dividerThickness: 1,
        dataTextStyle: TextStyle(
          fontFamily: 'Cairo',
          color: onBackground.withOpacity(0.87),
        ),
        headingTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
          color: onBackground.withOpacity(0.6),
        ),
      ),

      // === Lists ===
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        iconColor: onBackground.withOpacity(0.6),
      ),

      // === Floating Action Button ===
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary ??  const Color(0xfffbf2e6),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // === Chips ===
      chipTheme: ChipThemeData(
        backgroundColor: primary.withOpacity(0.12),
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: primary,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // === Tab Bar ===
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: onBackground.withOpacity(0.5),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primary, width: 3),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // === Progress Indicator ===
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: primary.withOpacity(0.2),
        circularTrackColor: primary.withOpacity(0.2),
      ),

      // === SnackBar ===
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,
        contentTextStyle: TextStyle(
          fontFamily: 'Cairo',
          color: onBackground,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: surface),
    );
  }

  /// Centralized method to generate a dark [ThemeData] configuration.
  static ThemeData _createDarkTheme({
    required String name,
    required Color primary,
    required Color secondary,
    required Color primaryVariant,
    required Color surface,
    required Color background,
    required Color onBackground,
    Brightness brightness = Brightness.dark,
    double elevation = 4.0,
    Color? onPrimary,
    Color? onSecondary,
  }) {
    // Determine optimal text color based on background luminance
    final effectiveOnPrimary = onPrimary ??
        (primary.computeLuminance() > 0.4 ? Colors.black :  const Color(0xfffbf2e6));
    final effectiveOnSecondary = onSecondary ??
        (secondary.computeLuminance() > 0.4 ? Colors.black :  const Color(0xfffbf2e6));

    return ThemeData.dark().copyWith(
      // === Basic Parameters ===
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      cardColor: surface,
      disabledColor: onBackground.withOpacity(0.38),

      // === Custom Theme Extension ===
      extensions: <ThemeExtension<dynamic>>[
        AppThemeInfo(name: name),
      ],

      // === AppBar ===
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onBackground,
        elevation: elevation,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onBackground,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(
          color: onBackground.withOpacity(0.8),
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: onBackground.withOpacity(0.8),
          size: 24,
        ),
      ),

      // === ColorScheme ===
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: effectiveOnPrimary,
        onSecondary: effectiveOnSecondary,
        onSurface: onBackground,
        primaryContainer: primary.withOpacity(0.2),
        secondaryContainer: secondary.withOpacity(0.2),
        error: const Color(0xFFCF6679),
        onError: Colors.black,
      ).copyWith(
        primaryContainer: primaryVariant,
      ),

      // === Typography ===
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: onBackground,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onBackground,
          letterSpacing: -0.3,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: onBackground,
          letterSpacing: -0.2,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onBackground.withOpacity(0.87),
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onBackground.withOpacity(0.6),
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onBackground.withOpacity(0.6),
        ),
      ),

      // === Buttons ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: effectiveOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: primary.withOpacity(0.4)),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // === Bottom Navigation Bar ===
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onBackground.withOpacity(0.5),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),

      // === Input Fields ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: onBackground.withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: onBackground.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onBackground.withOpacity(0.4),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onBackground.withOpacity(0.6),
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      // === Icons ===
      iconTheme: IconThemeData(
        color: onBackground.withOpacity(0.8),
        size: 24,
      ),

      // === Cards ===
      cardTheme: CardThemeData(
        color: surface,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // === Dividers ===
      dividerTheme: DividerThemeData(
        color: onBackground.withOpacity(0.2),
        thickness: 1,
        space: 0,
      ),

      // === Data Tables ===
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(
          onBackground.withOpacity(0.1),
        ),
        dataRowColor: WidgetStatePropertyAll(Colors.transparent),
        dividerThickness: 1,
        dataTextStyle: TextStyle(
          fontFamily: 'Cairo',
          color: onBackground.withOpacity(0.87),
        ),
        headingTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
          color: onBackground.withOpacity(0.6),
        ),
      ),

      // === Lists ===
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        iconColor: onBackground.withOpacity(0.6),
      ),

      // === Floating Action Button ===
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: effectiveOnPrimary,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // === Chips ===
      chipTheme: ChipThemeData(
        backgroundColor: primary.withOpacity(0.2),
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: primary,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // === Tab Bar ===
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: onBackground.withOpacity(0.5),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primary, width: 3),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // === Progress Indicator ===
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: primary.withOpacity(0.2),
        circularTrackColor: primary.withOpacity(0.2),
      ),

      // === SnackBar ===
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,
        contentTextStyle: TextStyle(
          fontFamily: 'Cairo',
          color: onBackground,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: surface),
    );
  }

  // ===========================================================================
  // Theme Collections
  // ===========================================================================

  /// A map containing all available light themes, keyed by their string identifier.
  static Map<String, ThemeData> get lightThemes => {
    'red': lightRed,
    'pink': lightPink,
    'purple': lightPurple,
    'deepPurple': lightDeepPurple,
    'indigo': lightIndigo,
    'blue': lightBlue,
    'lightBlue': lightLightBlue,
    'cyan': lightCyan,
    'teal': lightTeal,
    'green': lightGreen,
    'lightGreen': lightLightGreen,
    'lime': lightLime,
    'yellow': lightYellow,
    'amber': lightAmber,
    'orange': lightOrange,
    'deepOrange': lightDeepOrange,
    'brown': lightBrown,
    'grey': lightGrey,
    'blueGrey': lightBlueGrey,
  };

  /// A map containing all available dark themes, keyed by their string identifier.
  static Map<String, ThemeData> get darkThemes => {
    'red': darkRed,
    'pink': darkPink,
    'purple': darkPurple,
    'deepPurple': darkDeepPurple,
    'indigo': darkIndigo,
    'blue': darkBlue,
    'lightBlue': darkLightBlue,
    'cyan': darkCyan,
    'teal': darkTeal,
    'green': darkGreen,
    'lightGreen': darkLightGreen,
    'lime': darkLime,
    'yellow': darkYellow,
    'amber': darkAmber,
    'orange': darkOrange,
    'deepOrange': darkDeepOrange,
    'brown': darkBrown,
    'grey': darkGrey,
    'blueGrey': darkBlueGrey,
    'amoled': darkAmoled,
  };

  // ===========================================================================
  // Default Themes
  // ===========================================================================

  /// The fallback theme for light mode.
  static ThemeData get defaultLight => lightBlue;

  /// The fallback theme for dark mode.
  static ThemeData get defaultDark => darkBlue;

  // ===========================================================================
  // Theme Switching Helper
  // ===========================================================================

  /// Retrieves the appropriate [ThemeData] based on the current mode and selected color name.
  ///
  /// [isDarkMode] specifies whether the dark or light variant should be loaded.
  /// [themeName] is the string identifier (e.g., 'blue', 'red').
  /// Returns the matching theme, or the default theme if the name is not found.
  static ThemeData getTheme({required bool isDarkMode, String themeName = 'blue'}) {
    final themes = isDarkMode ? darkThemes : lightThemes;
    return themes[themeName] ?? (isDarkMode ? defaultDark : defaultLight);
  }

  // ===========================================================================
  // Theme Name Lists
  // ===========================================================================

  /// Returns a list of all available light theme keys.
  static List<String> get lightThemeNames => lightThemes.keys.toList();

  /// Returns a list of all available dark theme keys.
  static List<String> get darkThemeNames => darkThemes.keys.toList();
}

// ===========================================================================
// Custom Theme Extensions
// ===========================================================================

/// A custom theme extension to store additional metadata for the active theme.
///
/// Currently used to store the localized [name] of the theme (e.g., 'red', 'blue')
/// which can be accessed anywhere in the app via:
/// `Theme.of(context).extension<AppThemeInfo>()?.name`
class AppThemeInfo extends ThemeExtension<AppThemeInfo> {
  final String name;

  const AppThemeInfo({required this.name});

  @override
  ThemeExtension<AppThemeInfo> copyWith({String? name}) {
    return AppThemeInfo(name: name ?? this.name);
  }

  @override
  ThemeExtension<AppThemeInfo> lerp(
      ThemeExtension<AppThemeInfo>? other,
      double t,
      ) {
    if (other is! AppThemeInfo) {
      return this;
    }
    return AppThemeInfo(name: other.name);
  }
}