import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// A utility class for displaying beautiful and consistent toast notifications
/// across the application using the [toastification] package.
class SnackbarHelper {
  // Private constructor to prevent instantiation.
  SnackbarHelper._();

  /// Core private method to keep styling consistent across all toast types.
  ///
  /// Handles the common configuration such as animation, duration, alignment,
  /// and blur effects so that public methods remain clean and simple.
  static void _show({
    required String title,
    required String message,
    required ToastificationType type,
    ToastificationStyle style = ToastificationStyle.flatColored,
    IconData? icon,
    Duration? duration,
  }) {
    toastification.show(
      type: type,
      style: style,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 300),
      icon: icon != null ? Icon(icon) : null,
      showProgressBar: true,
      dragToClose: true,
      pauseOnHover: true,
      applyBlurEffect: true,
    );
  }

  /// Displays a success toast notification.
  ///
  /// Use this to confirm that a user's action was completed successfully
  /// (e.g., "Settings saved successfully", "Item added to favorites").
  static void showSuccess(String message, {String title = 'Success'}) {
    _show(
      title: title,
      message: message,
      type: ToastificationType.success,
      icon: Icons.check_circle_outline,
    );
  }

  /// Displays an error toast notification.
  ///
  /// Use this to inform the user about failures or critical issues
  /// (e.g., "No internet connection", "Failed to download file").
  static void showError(String message, {String title = 'Error'}) {
    _show(
      title: title,
      message: message,
      type: ToastificationType.error,
      icon: Icons.error_outline,
    );
  }

  /// Displays an informational toast notification.
  ///
  /// Use this for general updates or tips that don't require immediate action.
  static void showInfo(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      type: ToastificationType.info,
      icon: Icons.info_outline,
    );
  }

  /// Displays a warning toast notification.
  ///
  /// Use this to alert the user about potential issues or actions that
  /// might have unintended consequences (e.g., "Storage is almost full").
  static void showWarning(String message, {String title = 'Warning'}) {
    _show(
      title: title,
      message: message,
      type: ToastificationType.warning,
      icon: Icons.warning_amber_rounded,
    );
  }

  /// Clears all active toasts immediately.
  ///
  /// Useful when navigating away from a screen where old toasts are no longer relevant,
  /// or when a process is cancelled.
  static void clearAll() {
    toastification.dismissAll();
  }
}