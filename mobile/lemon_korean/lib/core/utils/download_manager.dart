/// Download Manager - Conditional Export
/// Mobile: Full download implementation
/// Web: Stub (always online mode)

export 'download_manager_mobile.dart'
    if (dart.library.html) '../platform/web/stubs/download_manager_stub.dart';
