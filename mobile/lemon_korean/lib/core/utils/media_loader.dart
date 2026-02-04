/// Media Loader - Conditional Export
/// Mobile: Full local storage + remote fallback
/// Web: CDN URLs only (browser caching)
library;

export 'media_loader_mobile.dart'
    if (dart.library.html) '../platform/web/stubs/media_loader_stub.dart';
