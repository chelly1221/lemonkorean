import 'package:web/web.dart' as web;

import '../../utils/app_logger.dart';
import '../secure_storage_interface.dart';

/// Web implementation of ISecureStorage using localStorage
/// Uses localStorage for persistence across browser sessions
class SecureStorageImpl implements ISecureStorage {
  // Use localStorage for persistence (not sessionStorage)
  final web.Storage _storage = web.window.localStorage;

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      _storage[key] = value;
    } catch (e) {
      AppLogger.e('Error writing $key', error: e, tag: 'SecureStorageWeb');
      // Silently fail - don't throw to avoid breaking login flow
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return _storage[key];
    } catch (e) {
      AppLogger.e('Error reading $key', error: e, tag: 'SecureStorageWeb');
      return null;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      _storage.removeItem(key);
    } catch (e) {
      AppLogger.e('Error deleting $key', error: e, tag: 'SecureStorageWeb');
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      _storage.clear();
    } catch (e) {
      AppLogger.e('Error clearing storage', error: e, tag: 'SecureStorageWeb');
    }
  }

  @override
  Future<bool> containsKey({required String key}) async {
    try {
      return _storage.getItem(key) != null;
    } catch (e) {
      AppLogger.e('Error checking key $key', error: e, tag: 'SecureStorageWeb');
      return false;
    }
  }
}
