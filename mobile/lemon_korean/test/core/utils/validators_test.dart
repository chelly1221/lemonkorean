import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_korean/core/utils/validators.dart';

void main() {
  group('Email Validation', () {
    test('returns error for empty email', () {
      expect(Validators.emailValidator(null), isNotNull);
      expect(Validators.emailValidator(''), isNotNull);
      expect(Validators.emailValidator('   '), isNotNull);
    });

    test('returns error for invalid email format', () {
      expect(Validators.emailValidator('invalid'), isNotNull);
      expect(Validators.emailValidator('invalid@'), isNotNull);
      expect(Validators.emailValidator('@example.com'), isNotNull);
      expect(Validators.emailValidator('test@.com'), isNotNull);
      expect(Validators.emailValidator('test@example'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(Validators.emailValidator('test@example.com'), isNull);
      expect(Validators.emailValidator('user.name@domain.org'), isNull);
      expect(Validators.emailValidator('user+tag@example.co.kr'), isNull);
    });

    test('returns error for email exceeding max length', () {
      final longEmail = '${'a' * 250}@test.com';
      expect(Validators.emailValidator(longEmail), isNotNull);
    });
  });

  group('Password Basic Validation', () {
    test('returns error for empty password', () {
      expect(Validators.passwordBasicValidator(null), isNotNull);
      expect(Validators.passwordBasicValidator(''), isNotNull);
    });

    test('returns error for short password', () {
      expect(Validators.passwordBasicValidator('12345'), isNotNull);
    });

    test('returns null for valid password', () {
      expect(Validators.passwordBasicValidator('password123'), isNull);
      expect(Validators.passwordBasicValidator('12345678'), isNull);
    });
  });

  group('Password Strict Validation', () {
    test('returns error for password without letters', () {
      expect(Validators.passwordStrictValidator('123456789'), isNotNull);
    });

    test('returns error for password without numbers', () {
      expect(Validators.passwordStrictValidator('abcdefgh'), isNotNull);
    });

    test('returns null for password with letters and numbers', () {
      expect(Validators.passwordStrictValidator('abc123def'), isNull);
      expect(Validators.passwordStrictValidator('Password1'), isNull);
    });
  });

  group('Confirm Password Validation', () {
    test('returns error when passwords do not match', () {
      final validator = Validators.confirmPasswordValidator(() => 'password123');
      expect(validator('different'), isNotNull);
    });

    test('returns error for empty confirmation', () {
      final validator = Validators.confirmPasswordValidator(() => 'password123');
      expect(validator(null), isNotNull);
      expect(validator(''), isNotNull);
    });

    test('returns null when passwords match', () {
      final validator = Validators.confirmPasswordValidator(() => 'password123');
      expect(validator('password123'), isNull);
    });
  });

  group('Username Validation', () {
    test('returns error for empty username', () {
      expect(Validators.usernameValidator(null), isNotNull);
      expect(Validators.usernameValidator(''), isNotNull);
      expect(Validators.usernameValidator('  '), isNotNull);
    });

    test('returns error for short username', () {
      expect(Validators.usernameValidator('a'), isNotNull);
    });

    test('returns error for long username', () {
      expect(Validators.usernameValidator('a' * 21), isNotNull);
    });

    test('returns null for valid username', () {
      expect(Validators.usernameValidator('user123'), isNull);
      expect(Validators.usernameValidator('test_user'), isNull);
      expect(Validators.usernameValidator('用户名'), isNull);
    });
  });

  group('Required Field Validation', () {
    test('returns error for empty value', () {
      final validator = Validators.requiredValidator('字段');
      expect(validator(null), isNotNull);
      expect(validator(''), isNotNull);
      expect(validator('   '), isNotNull);
    });

    test('returns null for non-empty value', () {
      final validator = Validators.requiredValidator('字段');
      expect(validator('有值'), isNull);
    });
  });

  group('Combined Validators', () {
    test('stops at first error', () {
      final validator = Validators.combine([
        Validators.requiredValidator('邮箱'),
        Validators.emailValidator,
      ]);

      // Empty value - first validator fails
      expect(validator(''), contains('邮箱'));

      // Invalid email - second validator fails
      expect(validator('invalid'), contains('有效'));

      // Valid email - no error
      expect(validator('test@example.com'), isNull);
    });
  });

  group('ValidationResult', () {
    test('valid result returns null error', () {
      const result = ValidationResult.valid();
      expect(result.isValid, isTrue);
      expect(result.toFormError(), isNull);
    });

    test('invalid result returns error message', () {
      const result = ValidationResult.invalid('错误信息');
      expect(result.isValid, isFalse);
      expect(result.toFormError(), equals('错误信息'));
    });
  });
}
