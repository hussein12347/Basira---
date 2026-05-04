import 'package:dio/dio.dart';

/// A base abstract class for handling errors and failures across the application.
abstract class Failure {
  /// The error message that will be displayed to the user.
  final String errMessage;

  /// Constructs a [Failure] with the given [errMessage].
  const Failure(this.errMessage);
}

/// Represents exceptions that occur during API/Server communications.
class ServerFailure extends Failure {
  /// Constructs a [ServerFailure] with the given [errMessage].
  ServerFailure(super.errMessage);

  /// Factory constructor that maps a [DioException] to a user-friendly [ServerFailure].
  ///
  /// It intercepts various Dio exception types (like timeouts and connection errors)
  /// and translates them into readable error messages.
  factory ServerFailure.fromDioException(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.connectionError: // Important case in recent Dio versions
        return ServerFailure('No Internet Connection');
      case DioExceptionType.badCertificate:
        return ServerFailure('Internal Certificate Error');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was cancelled');
      case DioExceptionType.unknown:
        if (dioError.message != null && dioError.message!.contains('SocketException')) {
          return ServerFailure('No Internet Connection');
        }
        return ServerFailure('Unexpected Error, Please try again!');
      default:
        return ServerFailure('Oops, There was an Error, Please try again');
    }
  }

  /// Factory constructor that maps HTTP status codes and responses to a [ServerFailure].
  ///
  /// Designed to handle common responses (e.g., from Supabase).
  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    // Handling common Supabase responses.
    // Note: Supabase sometimes returns the error inside a map called 'message' or 'msg'.
    String errorMessage = response?['error_description'] ??
        response?['message'] ??
        response?['msg'] ??
        'Oops There was an Error, Please try again';

    if (statusCode == 400) {
      // Mostly Auth errors (e.g., weak password, email already exists)
      return ServerFailure(errorMessage);
    } else if (statusCode == 401) {
      return ServerFailure('Unauthorized: Please login again');
    } else if (statusCode == 403) {
      return ServerFailure('Forbidden: You don\'t have permission');
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try later!');
    } else if (statusCode == 409) {
      return ServerFailure('Conflict: Data already exists');
    } else if (statusCode == 429) {
      return ServerFailure('Too many requests, slow down!');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server error, Please try later');
    } else {
      return ServerFailure('Status code: $statusCode. Please try again');
    }
  }
}