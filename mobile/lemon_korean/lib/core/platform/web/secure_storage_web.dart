import 'dart:html' as html;

import '../secure_storage_interface.dart';

/// Web implementation of ISecureStorage using localStorage
/// Uses localStorage for persistence across browser sessions
class SecureStorageImpl implements ISecureStorage {
  // Use localStorage for persistence (not sessionStorage)
  final html.Storage _storage = html.window.localStorage;

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      _storage[key] = value;
    } catch (e) {
      print('[SecureStorage.web] Error writing $key: $e');
      // Silently fail - don't throw to avoid breaking login flow
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return _storage[key];
    } catch (e) {
      print('[SecureStorage.web] Error reading $key: $e');
      return null;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      _storage.remove(key);
    } catch (e) {
      print('[SecureStorage.web] Error deleting $key: $e');
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      _storage.clear();
    } catch (e) {
      print('[SecureStorage.web] Error clearing storage: $e');
    }
  }

  @override
  Future<bool> containsKey({required String key}) async {
    try {
      return _storage.containsKey(key);
    } catch (e) {
      print('[SecureStorage.web] Error checking key $key: $e');
      return false;
    }
  }
}
