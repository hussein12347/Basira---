import 'package:flutter/material.dart';

/// A custom painter that draws a circular indicator resembling a pie chart.
///
/// It is specifically designed to visually represent the 4 quarters of a Quranic Hizb.
/// The circle fills up clockwise starting from the top center (12 o'clock position)
/// based on the [qInHizb] index.
class QuarterCirclePainter extends CustomPainter {
  /// The index representing the quarter of the Hizb (0, 1, 2, or 3).
  final int qInHizb;

  /// The color used to fill the active arc (the pie slice).
  final Color primaryColor;

  /// The color used for the background circle and border.
  final Color secondaryColor;

  QuarterCirclePainter({
    required this.qInHizb,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw the background circle (light tinted fill)
    final backgroundPaint = Paint()
      ..color = secondaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // 2. Draw the border of the circle
    final borderPaint = Paint()
      ..color = secondaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius, borderPaint);

    // 3. Draw the filled arc (pie slice) based on the current quarter
    if (qInHizb >= 0) {
      final fillPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;

      double sweepAngle = 0;

      // Determine the sweep angle based on the quarter index.
      // Note: Math.pi (3.1415...) is equal to 180 degrees.
      switch (qInHizb) {
        case 0: // Hizb Start
          sweepAngle = 0.0; // 0 degrees (Empty)
          break;
        case 1: // 1/4 Hizb
          sweepAngle = 0.5 * 3.141592653589793; // 90 degrees
          break;
        case 2: // 1/2 Hizb
          sweepAngle = 3.141592653589793; // 180 degrees
          break;
        case 3: // 3/4 Hizb
          sweepAngle = 1.5 * 3.141592653589793; // 270 degrees
          break;
      }

      // Draw the arc if there is an angle to fill
      if (sweepAngle > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -3.141592653589793 / 2, // Start from the top (-90 degrees)
          sweepAngle,
          true, // Use center to form a closed "pie slice"
          fillPaint,
        );
      }
    }
  }

  /// Determines whether the canvas needs to be repainted.
  ///
  /// It optimizes performance by only repainting if the quarter index
  /// or the theme colors change.
  @override
  bool shouldRepaint(covariant QuarterCirclePainter oldDelegate) {
    return oldDelegate.qInHizb != qInHizb ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}