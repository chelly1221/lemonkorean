import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_service.dart';

/// AdMob implementation for mobile (Android).
/// Uses Google's rewarded ads for lemon tree harvest.
class AdMobService implements AdService {
  RewardedAd? _rewardedAd;
  bool _isAdReady = false;

  // Fallback test ad unit ID
  static const String _testRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';

  /// Server-provided ad unit ID (set via [setAdUnitId]).
  String? _serverAdUnitId;

  /// Set the rewarded ad unit ID from server settings.
  @override
  void setAdUnitId(String? adUnitId) {
    _serverAdUnitId = adUnitId;
  }

  String get _rewardedAdUnitId =>
      kDebugMode ? _testRewardedAdId : (_serverAdUnitId ?? _testRewardedAdId);

  @override
  bool get isAdReady => _isAdReady;

  @override
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await preloadAd();
  }

  @override
  Future<void> preloadAd() async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdReady = true;
          debugPrint('[AdMob] Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _isAdReady = false;
          debugPrint('[AdMob] Failed to load rewarded ad: ${error.message}');
        },
      ),
    );
  }

  @override
  Future<bool> showRewardedAd() async {
    if (_rewardedAd == null || !_isAdReady) {
      debugPrint('[AdMob] Ad not ready, attempting to load...');
      await preloadAd();
      // Wait a bit for the ad to load
      await Future.delayed(const Duration(seconds: 2));
      if (_rewardedAd == null) return false;
    }

    final completer = Completer<bool>();

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;
        if (!completer.isCompleted) completer.complete(false);
        preloadAd(); // Preload next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;
        if (!completer.isCompleted) completer.complete(false);
        preloadAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('[AdMob] User earned reward: ${reward.amount} ${reward.type}');
        if (!completer.isCompleted) completer.complete(true);
      },
    );

    return completer.future;
  }
}
