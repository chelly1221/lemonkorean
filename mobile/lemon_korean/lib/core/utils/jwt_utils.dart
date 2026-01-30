import 'dart:convert';

import 'app_logger.dart';

/// JWT Utility for decoding tokens
/// Used to extract user_id from JWT for validation
class JwtUtils {
  static const String _tag = 'JwtUtils';

  /// Decode JWT token payload
  /// Returns null if token is invalid
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (second part)
      String payload = parts[1];

      // Add padding if needed for base64
      switch (payload.length % 4) {
        case 1:
          payload += '===';
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
      final decoded = base64.decode(normalized);
      final jsonString = utf8.decode(decoded);

      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.w('Error decoding token: $e', tag: _tag);
      return null;
    }
  }

  /// Extract user ID from JWT token
  /// Returns null if token is invalid or userId not found
  static int? getUserIdFromToken(String token) {
    final payload = decodeToken(token);
    if (payload == null) return null;

    // Try common JWT claim names for user ID
    final userId = payload['userId'] ?? payload['user_id'] ?? payload['sub'];

    if (userId is int) return userId;
    if (userId is String) return int.tryParse(userId);

    return null;
  }

  /// Check if token is expired
  /// Returns true if expired or invalid
  static bool isTokenExpired(String token) {
    final payload = decodeToken(token);
    if (payload == null) return true;

    final exp = payload['exp'];
    if (exp == null) return false; // No expiration

    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiry);
  }
}
