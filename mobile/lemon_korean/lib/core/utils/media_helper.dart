/// Media Helper - Conditional Export
/// Mobile: Local file + remote fallback
/// Web: CDN URLs only
library;

export 'media_helper_mobile.dart'
    if (dart.library.html) '../platform/web/stubs/media_helper_stub.dart';
