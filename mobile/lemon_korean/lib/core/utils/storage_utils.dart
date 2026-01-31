/// Storage Utilities - Conditional Export
/// Mobile: Real device storage via df command
/// Web: localStorage capacity estimation

export 'storage_utils_mobile.dart'
    if (dart.library.html) '../platform/web/stubs/storage_utils_stub.dart';
