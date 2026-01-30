/// Input Validators
/// Centralized validation logic for forms

import '../constants/app_constants.dart';

/// Validation result with optional error message
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult.valid() : isValid = true, errorMessage = null;
  const ValidationResult.invalid(this.errorMessage) : isValid = false;

  /// Convert to FormField validator format (null = valid, String = error)
  String? toFormError() => isValid ? null : errorMessage;
}

/// Centralized validators for common input types
class Validators {
  Validators._(); // Private constructor

  // ================================================================
  // EMAIL VALIDATION
  // ================================================================

  /// Email regex pattern (RFC 5322 simplified)
  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validate email address
  static ValidationResult validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('请输入邮箱');
    }

    final trimmed = value.trim();

    if (trimmed.length > 254) {
      return const ValidationResult.invalid('邮箱地址过长');
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return const ValidationResult.invalid('请输入有效的邮箱地址');
    }

    return const ValidationResult.valid();
  }

  /// FormField validator for email
  static String? emailValidator(String? value) {
    return validateEmail(value).toFormError();
  }

  // ================================================================
  // PASSWORD VALIDATION
  // ================================================================

  /// Check if password contains letters
  static final RegExp _hasLetter = RegExp(r'[a-zA-Z]');

  /// Check if password contains numbers
  static final RegExp _hasNumber = RegExp(r'[0-9]');

  /// Check if password contains special characters
  static final RegExp _hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  /// Validate password (login - basic check)
  static ValidationResult validatePasswordBasic(String? value) {
    if (value == null || value.isEmpty) {
      return const ValidationResult.invalid('请输入密码');
    }

    if (value.length < AppConstants.minPasswordLength) {
      return ValidationResult.invalid(
        '密码至少需要${AppConstants.minPasswordLength}个字符',
      );
    }

    return const ValidationResult.valid();
  }

  /// Validate password (registration - strict check)
  static ValidationResult validatePasswordStrict(String? value) {
    // Basic checks first
    final basicResult = validatePasswordBasic(value);
    if (!basicResult.isValid) {
      return basicResult;
    }

    // Must contain letter and number
    if (!_hasLetter.hasMatch(value!)) {
      return const ValidationResult.invalid('密码必须包含字母');
    }

    if (!_hasNumber.hasMatch(value)) {
      return const ValidationResult.invalid('密码必须包含数字');
    }

    return const ValidationResult.valid();
  }

  /// Validate password with all requirements (optional special char)
  static ValidationResult validatePasswordFull(
    String? value, {
    bool requireSpecial = false,
  }) {
    final strictResult = validatePasswordStrict(value);
    if (!strictResult.isValid) {
      return strictResult;
    }

    if (requireSpecial && !_hasSpecial.hasMatch(value!)) {
      return const ValidationResult.invalid('密码必须包含特殊字符');
    }

    if (value!.length > 128) {
      return const ValidationResult.invalid('密码过长');
    }

    return const ValidationResult.valid();
  }

  /// FormField validator for password (basic)
  static String? passwordBasicValidator(String? value) {
    return validatePasswordBasic(value).toFormError();
  }

  /// FormField validator for password (strict)
  static String? passwordStrictValidator(String? value) {
    return validatePasswordStrict(value).toFormError();
  }

  /// Create confirm password validator
  static String? Function(String?) confirmPasswordValidator(
    String Function() getPassword,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '请再次输入密码';
      }
      if (value != getPassword()) {
        return '两次输入的密码不一致';
      }
      return null;
    };
  }

  // ================================================================
  // USERNAME VALIDATION
  // ================================================================

  /// Username allowed characters (letters, numbers, underscores, Chinese)
  static final RegExp _usernamePattern = RegExp(r'^[\w\u4e00-\u9fa5]+$');

  /// Validate username
  static ValidationResult validateUsername(
    String? value, {
    int minLength = 2,
    int maxLength = 20,
  }) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationResult.invalid('请输入用户名');
    }

    final trimmed = value.trim();

    if (trimmed.length < minLength) {
      return ValidationResult.invalid('用户名至少需要$minLength个字符');
    }

    if (trimmed.length > maxLength) {
      return ValidationResult.invalid('用户名不能超过$maxLength个字符');
    }

    // Check for valid characters
    if (!_usernamePattern.hasMatch(trimmed)) {
      return const ValidationResult.invalid('用户名只能包含字母、数字、下划线和中文');
    }

    return const ValidationResult.valid();
  }

  /// FormField validator for username
  static String? usernameValidator(String? value) {
    return validateUsername(value).toFormError();
  }

  // ================================================================
  // GENERAL VALIDATORS
  // ================================================================

  /// Validate required field
  static ValidationResult validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('请输入$fieldName');
    }
    return const ValidationResult.valid();
  }

  /// Create required field validator
  static String? Function(String?) requiredValidator(String fieldName) {
    return (String? value) {
      return validateRequired(value, fieldName).toFormError();
    };
  }

  /// Validate minimum length
  static ValidationResult validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.length < minLength) {
      return ValidationResult.invalid('$fieldName至少需要$minLength个字符');
    }
    return const ValidationResult.valid();
  }

  /// Validate maximum length
  static ValidationResult validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value != null && value.length > maxLength) {
      return ValidationResult.invalid('$fieldName不能超过$maxLength个字符');
    }
    return const ValidationResult.valid();
  }

  /// Validate numeric input
  static ValidationResult validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('请输入$fieldName');
    }
    if (int.tryParse(value) == null) {
      return ValidationResult.invalid('$fieldName必须是数字');
    }
    return const ValidationResult.valid();
  }

  // ================================================================
  // COMPOSITE VALIDATORS
  // ================================================================

  /// Combine multiple validators (stops at first error)
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
