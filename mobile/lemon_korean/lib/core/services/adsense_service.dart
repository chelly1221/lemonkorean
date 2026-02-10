import 'dart:async';

import 'package:flutter/foundation.dart';

import 'ad_service.dart';

/// AdSense implementation for web platform.
/// Since AdSense doesn't support rewarded ads directly,
/// this uses a simplified flow: show an interstitial-style overlay,
/// then grant the reward after a delay.
class AdSenseService implements AdService {
  bool _isInitialized = false;

  @override
  bool get isAdReady => _isInitialized;

  @override
  Future<void> initialize() async {
    // AdSense is initialized via the script tag in index.html
    // We just mark ourselves as ready
    _isInitialized = true;
    debugPrint('[AdSense] Service initialized');
  }

  @override
  Future<void> preloadAd() async {
    // No preloading needed for web ads
  }

  @override
  void setAdUnitId(String? adUnitId) {
    // No-op on web (AdSense doesn't use ad unit IDs the same way)
  }

  @override
  Future<bool> showRewardedAd() async {
    if (!_isInitialized) return false;

    // For web: simulate a rewarded experience
    // In production, this would call AdSense JS API for interstitial ads
    // For now, we grant the reward directly (no real ad on web)
    //
    // TODO: Integrate AdSense interstitial via dart:js_interop when
    // AdSense account is configured. For now, web users get free harvests.
    debugPrint('[AdSense] Web reward granted (no ad shown in dev)');
    return true;
  }
}
