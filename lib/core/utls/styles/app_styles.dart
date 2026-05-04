import 'package:elda3ia_tour/core/utls/styles/size_config.dart';
import 'package:flutter/material.dart';

/// A centralized typography configuration class for the application.
///
/// This class provides predefined, responsive [TextStyle]s using the 'Cairo' font.
/// It automatically adjusts font sizes based on the screen width and adapts
/// the text color according to the current theme (Light or Dark mode).
abstract class AppStyles {

  /// Core private method to generate a consistent [TextStyle].
  ///
  /// Applies the 'Cairo' font family, calculates the responsive font size,
  /// and automatically switches colors based on the theme's brightness.
  static TextStyle _generateStyle(
      BuildContext context, {
        required double fontSize,
        required FontWeight fontWeight,
        Color? color,
      }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: getResponsiveFontSize(context, fontSize: fontSize),
      fontWeight: fontWeight,
      // Defaults to White in Dark Mode, Black in Light Mode.
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    );
  }

  // ==========================================
  // Regular Styles (FontWeight.w400)
  // ==========================================
  static TextStyle regular12(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle regular14(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 14, fontWeight: FontWeight.w400, color: color);

  static TextStyle regular16(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 16, fontWeight: FontWeight.w400, color: color);

  static TextStyle regular18(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 18, fontWeight: FontWeight.w400, color: color);

  static TextStyle regular20(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 20, fontWeight: FontWeight.w400, color: color);

  static TextStyle regular24(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 24, fontWeight: FontWeight.w400, color: color);

  static TextStyle regular28(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 28, fontWeight: FontWeight.w400, color: color);

  // ==========================================
  // Medium Styles (FontWeight.w500)
  // ==========================================
  static TextStyle medium14(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 14, fontWeight: FontWeight.w500, color: color);

  static TextStyle medium16(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 16, fontWeight: FontWeight.w500, color: color);

  static TextStyle medium18(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 18, fontWeight: FontWeight.w500, color: color);

  static TextStyle medium20(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 20, fontWeight: FontWeight.w500, color: color);

  static TextStyle medium24(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 24, fontWeight: FontWeight.w500, color: color);

  static TextStyle medium29(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 29, fontWeight: FontWeight.w500, color: color);

  // ==========================================
  // SemiBold Styles (FontWeight.w600)
  // ==========================================
  static TextStyle semiBold14(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 14, fontWeight: FontWeight.w600, color: color);

  static TextStyle semiBold16(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 16, fontWeight: FontWeight.w600, color: color);

  static TextStyle semiBold18(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 18, fontWeight: FontWeight.w600, color: color);

  static TextStyle semiBold20(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 20, fontWeight: FontWeight.w600, color: color);

  static TextStyle semiBold24(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 24, fontWeight: FontWeight.w600, color: color);

  static TextStyle semiBold28(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 28, fontWeight: FontWeight.w600, color: color);

  static TextStyle semiBold32(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 32, fontWeight: FontWeight.w600, color: color);

  // ==========================================
  // Bold Styles (FontWeight.w700)
  // ==========================================
  static TextStyle bold16(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 16, fontWeight: FontWeight.w700, color: color ?? Theme.of(context).colorScheme.primary);

  static TextStyle bold20(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 20, fontWeight: FontWeight.w700, color: color);

  static TextStyle bold24(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 24, fontWeight: FontWeight.w700, color: color);

  static TextStyle bold32(BuildContext context, {Color? color}) =>
      _generateStyle(context, fontSize: 32, fontWeight: FontWeight.w700, color: color);

  /// An alternative base style generator without the color parameter.
  static TextStyle _baseStyle(
      BuildContext context, {
        required double fontSize,
        required FontWeight fontWeight,
      }) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: getResponsiveFontSize(context, fontSize: fontSize),
      fontWeight: fontWeight,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    );
  }
}

// ==========================================
// Responsive Font Size Utilities
// ==========================================

/// Calculates a responsive font size based on the device's screen width.
///
/// It uses a scale factor and applies limits (`clamp`) to ensure the font
/// doesn't become excessively small on tiny screens or overly huge on large screens.
double getResponsiveFontSize(context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;

  // You can get the fontScale from a Cubit for finer control,
  // or rely on TextScaler in MediaQuery as done in previous steps.

  // Set lower and upper boundaries to maintain UI integrity.
  double lowerLimit = fontSize * .8;
  double upperLimit = fontSize * 1.2;

  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

/// Determines the scale factor for typography based on predefined screen breakpoints.
///
/// It checks the device's width and compares it against mobile, tablet,
/// and desktop breakpoints defined in [SizeConfig].
double getScaleFactor(context) {
  // var dispatcher = PlatformDispatcher.instance;
  // var physicalWidth = dispatcher.views.first.physicalSize.width;
  // var devicePixelRatio = dispatcher.views.first.devicePixelRatio;
  // double width = physicalWidth / devicePixelRatio;

  double width = MediaQuery.sizeOf(context).width;

  if (width < SizeConfig.tablet) {
    // Mobile scaling factor
    return width / 810;
  } else if (width < SizeConfig.desktop) {
    // Tablet scaling factor
    return width / 1010;
  } else {
    // Desktop scaling factor
    return width / 1920;
  }
}