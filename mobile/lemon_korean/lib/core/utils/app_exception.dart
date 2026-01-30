import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'result.dart';

/// Base exception class for the application
class AppException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    required this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException($code): $message';

  /// Convert to Error result
  Error<T> toError<T>({T? cachedData}) {
    return Error<T>(message, code: code, cachedData: cachedData);
  }
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    String message = '网络连接失败，请检查您的网络设置',
    String code = ErrorCodes.networkError,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Server-related exceptions
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    String message = '服务器错误，请稍后重试',
    String code = ErrorCodes.serverError,
    this.statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    String message = '认证失败，请重新登录',
    String code = ErrorCodes.authError,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Resource not found exceptions
class NotFoundException extends AppException {
  const NotFoundException({
    String message = '请求的资源不存在',
    String code = ErrorCodes.notFound,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    String message = '请求参数错误',
    String code = ErrorCodes.validationError,
    this.fieldErrors,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Parse/Decode exceptions
class ParseException extends AppException {
  const ParseException({
    String message = '数据解析错误',
    String code = ErrorCodes.parseError,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Utility class for handling exceptions
class ExceptionHandler {
  /// Convert any exception to AppException
  static AppException handle(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioException(error, stackTrace);
    }

    if (error is FormatException) {
      return ParseException(
        message: '数据格式错误',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return AppException(
      message: error?.toString() ?? AppConstants.unknownErrorMessage,
      code: ErrorCodes.unknownError,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Convert DioException to AppException
  static AppException _handleDioException(DioException error, StackTrace? stackTrace) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: '连接超时，请检查网络',
          code: ErrorCodes.timeout,
          originalError: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: AppConstants.networkErrorMessage,
          originalError: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.cancel:
        return AppException(
          message: '请求已取消',
          code: ErrorCodes.cancelled,
          originalError: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response, error, stackTrace);

      default:
        return NetworkException(
          message: AppConstants.unknownErrorMessage,
          originalError: error,
          stackTrace: stackTrace,
        );
    }
  }

  /// Handle HTTP response errors
  static AppException _handleResponseError(
    Response? response,
    DioException error,
    StackTrace? stackTrace,
  ) {
    if (response == null) {
      return ServerException(
        message: AppConstants.serverErrorMessage,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    final statusCode = response.statusCode;
    final data = response.data;
    final message = data is Map ? data['message'] as String? : null;

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message ?? '请求参数错误',
          originalError: error,
          stackTrace: stackTrace,
        );

      case 401:
        return AuthException(
          message: message ?? AppConstants.authErrorMessage,
          originalError: error,
          stackTrace: stackTrace,
        );

      case 403:
        return AuthException(
          message: message ?? '没有权限访问',
          code: 'FORBIDDEN',
          originalError: error,
          stackTrace: stackTrace,
        );

      case 404:
        return NotFoundException(
          message: message ?? '请求的资源不存在',
          originalError: error,
          stackTrace: stackTrace,
        );

      case 429:
        return ServerException(
          message: '请求过于频繁，请稍后重试',
          code: 'RATE_LIMITED',
          statusCode: statusCode,
          originalError: error,
          stackTrace: stackTrace,
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          message: message ?? AppConstants.serverErrorMessage,
          statusCode: statusCode,
          originalError: error,
          stackTrace: stackTrace,
        );

      default:
        return ServerException(
          message: message ?? AppConstants.unknownErrorMessage,
          statusCode: statusCode,
          originalError: error,
          stackTrace: stackTrace,
        );
    }
  }
}
