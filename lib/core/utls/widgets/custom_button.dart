import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

/// A highly reusable, fully customizable button widget used throughout the app.
///
/// It provides a consistent design language with rounded corners, a default
/// height, and responsive text scaling to prevent overflow issues on smaller devices.
class CustomButton extends StatelessWidget {
  /// Constructs a [CustomButton].
  ///
  /// [onPressed] and [text] are required. If [backgroundColor] is not provided,
  /// it defaults to the current theme's secondary color.
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height = 54,
    this.backgroundColor,
    this.width = double.infinity,
  });

  /// The callback that is called when the button is tapped or otherwise activated.
  final VoidCallback onPressed;

  /// The text label displayed inside the button.
  final String text;

  /// The background color of the button.
  ///
  /// If null, it falls back to `Theme.of(context).colorScheme.secondary`.
  final Color? backgroundColor;

  /// The vertical extent of the button. Defaults to 54.
  final double height;

  /// The horizontal extent of the button. Defaults to [double.infinity]
  /// to expand and fill its parent's width.
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          // Use provided color or default to the theme's secondary color
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        // FittedBox ensures the text shrinks instead of overflowing
        // if the button's width is too small for the text length.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            // Forces the text color to white to maintain contrast
            // against the typically colored button background.
            style: AppStyles.semiBold18(context).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}