part of 'download_cubit.dart';

/// The base class for all states emitted by the [DownloadCubit].
///
/// Marked as [@immutable] to enforce state immutability, a core
/// principle of the Bloc/Cubit pattern.
@immutable
abstract class DownloadState {}

/// The initial state of the cubit before any download or delete action occurs.
class DownloadInitial extends DownloadState {}

/// Emitted continuously while a download or delete operation is in progress.
class DownloadLoading extends DownloadState {
  /// The current progress of the overall operation, represented as a value from 0.0 to 1.0.
  final double progress;

  DownloadLoading(this.progress);
}

/// Emitted when a download operation is successfully completed.
class DownloadSuccess extends DownloadState {
  /// Can contain the specific file path, or a general success message like "Batch download complete".
  final String filePath;

  DownloadSuccess(this.filePath);
}

/// Emitted when a deletion operation is successfully completed.
///
/// ✅ A dedicated state to easily distinguish deletion success from download success in the UI.
class DeleteSuccess extends DownloadState {}

/// Emitted when an error occurs during a download or delete operation.
class DownloadError extends DownloadState {
  /// The error message describing what went wrong.
  final String message;

  DownloadError(this.message);
}