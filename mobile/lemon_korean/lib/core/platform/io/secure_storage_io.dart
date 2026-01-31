import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../secure_storage_interface.dart';

/// Mobile implementation of ISecureStorage using FlutterSecureStorage
class SecureStorageImpl implements ISecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<bool> containsKey({required String key}) =>
      _storage.containsKey(key: key);
}
