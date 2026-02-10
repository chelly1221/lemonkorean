// Web stub: exports AdSenseService as AdMobService for conditional import compatibility
export 'adsense_service.dart' show AdSenseService;

import 'adsense_service.dart';

/// On web, AdMobService is an alias for AdSenseService.
/// This allows conditional import to resolve AdMobService on all platforms.
typedef AdMobService = AdSenseService;
