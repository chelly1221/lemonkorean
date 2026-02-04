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
    super.message = '네트워크 연결 실패. 네트워크 설정을 확인하세요',
    super.code = ErrorCodes.networkError,
    super.originalError,
    super.stackTrace,
  });
}

/// Server-related exceptions
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    super.message = '서버 오류. 나중에 다시 시도하세요',
    super.code = ErrorCodes.serverError,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    super.message = '인증 실패. 다시 로그인하세요',
    super.code = ErrorCodes.authError,
    super.originalError,
    super.stackTrace,
  });
}

/// Resource not found exceptions
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = '요청한 리소스가 존재하지 않습니다',
    super.code = ErrorCodes.notFound,
    super.originalError,
    super.stackTrace,
  });
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    super.message = '요청 파라미터 오류',
    super.code = ErrorCodes.validationError,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });
}

/// Parse/Decode exceptions
class ParseException extends AppException {
  const ParseException({
    super.message = '데이터 파싱 오류',
    super.code = ErrorCodes.parseError,
    super.originalError,
    super.stackTrace,
  });
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
        message: '데이터 형식 오류',
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
          message: '연결 시간 초과. 네트워크를 확인하세요',
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
          message: '요청이 취소되었습니다',
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
          message: message ?? '요청 파라미터 오류',
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
          message: message ?? '접근 권한이 없습니다',
          code: 'FORBIDDEN',
          originalError: error,
          stackTrace: stackTrace,
        );

      case 404:
        return NotFoundException(
          message: message ?? '요청한 리소스가 존재하지 않습니다',
          originalError: error,
          stackTrace: stackTrace,
        );

      case 429:
        return ServerException(
          message: '요청이 너무 많습니다. 나중에 다시 시도하세요',
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
