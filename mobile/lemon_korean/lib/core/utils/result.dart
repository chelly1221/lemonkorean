/// Result type for handling success and error states
/// Provides a type-safe way to handle operations that can fail
sealed class Result<T> {
  const Result();

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is an error result
  bool get isError => this is Error<T>;

  /// Returns the data if success, otherwise null
  T? get dataOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Returns the error message if error, otherwise null
  String? get errorOrNull {
    if (this is Error<T>) {
      return (this as Error<T>).message;
    }
    return null;
  }

  /// Map success value to another type
  Result<R> map<R>(R Function(T data) mapper) {
    if (this is Success<T>) {
      return Success(mapper((this as Success<T>).data),
          isFromCache: (this as Success<T>).isFromCache);
    }
    final error = this as Error<T>;
    return Error(error.message, code: error.code, cachedData: null);
  }

  /// Execute different callbacks based on result type
  R when<R>({
    required R Function(T data, bool isFromCache) success,
    required R Function(String message, String? code, T? cachedData) error,
  }) {
    if (this is Success<T>) {
      final s = this as Success<T>;
      return success(s.data, s.isFromCache);
    } else {
      final e = this as Error<T>;
      return error(e.message, e.code, e.cachedData);
    }
  }

  /// Execute callback only on success
  void onSuccess(void Function(T data) callback) {
    if (this is Success<T>) {
      callback((this as Success<T>).data);
    }
  }

  /// Execute callback only on error
  void onError(void Function(String message, String? code) callback) {
    if (this is Error<T>) {
      final e = this as Error<T>;
      callback(e.message, e.code);
    }
  }
}

/// Success result containing data
class Success<T> extends Result<T> {
  final T data;
  final bool isFromCache;

  const Success(this.data, {this.isFromCache = false});

  @override
  String toString() => 'Success(data: $data, isFromCache: $isFromCache)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> &&
        other.data == data &&
        other.isFromCache == isFromCache;
  }

  @override
  int get hashCode => data.hashCode ^ isFromCache.hashCode;
}

/// Error result containing error information
class Error<T> extends Result<T> {
  final String message;
  final String? code;
  final T? cachedData;

  const Error(this.message, {this.code, this.cachedData});

  @override
  String toString() =>
      'Error(message: $message, code: $code, cachedData: $cachedData)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Error<T> &&
        other.message == message &&
        other.code == code &&
        other.cachedData == cachedData;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode ^ cachedData.hashCode;
}

/// Common error codes for the application
class ErrorCodes {
  static const String networkError = 'NETWORK_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String authError = 'AUTH_ERROR';
  static const String notFound = 'NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';
  static const String timeout = 'TIMEOUT';
  static const String cancelled = 'CANCELLED';
  static const String parseError = 'PARSE_ERROR';
}

/// Extension to convert Future<T> to Future<Result<T>>
extension FutureResultExtension<T> on Future<T> {
  /// Wrap a Future in a Result, catching any errors
  Future<Result<T>> toResult() async {
    try {
      final data = await this;
      return Success(data);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
