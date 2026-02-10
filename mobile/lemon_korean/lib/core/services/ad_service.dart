/// Abstract interface for ad services.
/// Platform-specific implementations: AdMob (mobile) and AdSense (web).
abstract class AdService {
  /// Initialize the ad service
  Future<void> initialize();

  /// Show a rewarded ad. Returns true if the user completed watching
  /// and should receive the reward.
  Future<bool> showRewardedAd();

  /// Whether ads are available (loaded and ready to show)
  bool get isAdReady;

  /// Preload the next ad
  Future<void> preloadAd();

  /// Set the ad unit ID from server settings. No-op by default.
  void setAdUnitId(String? adUnitId) {}
}
