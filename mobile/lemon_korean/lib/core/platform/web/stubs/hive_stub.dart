/// Stub for Hive (web build)
/// This file is imported when building for web to avoid importing hive_flutter
class Hive {
  static Future<void> initFlutter() async {
    // Stub - web uses IndexedDB via PlatformFactory
  }

  static Future<Box> openBox(String name) async {
    throw UnsupportedError('Hive not supported on web');
  }
}

class Box {
  Future<void> put(String key, dynamic value) async {
    throw UnsupportedError('Hive not supported on web');
  }

  dynamic get(String key) {
    throw UnsupportedError('Hive not supported on web');
  }

  Iterable get values => [];

  bool containsKey(String key) => false;

  Future<void> delete(String key) async {}

  Future<void> clear() async {}

  Future<void> close() async {}

  int get length => 0;
}
