/// Platform-agnostic secure storage interface
/// Implemented by IO (FlutterSecureStorage) and Web (sessionStorage)
abstract class ISecureStorage {
  /// Write a key-value pair
  Future<void> write({required String key, required String value});

  /// Read a value by key
  Future<String?> read({required String key});

  /// Delete a value by key
  Future<void> delete({required String key});

  /// Delete all stored values
  Future<void> deleteAll();

  /// Check if a key exists
  Future<bool> containsKey({required String key});
}
