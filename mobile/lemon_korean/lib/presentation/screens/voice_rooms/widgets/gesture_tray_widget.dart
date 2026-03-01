import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/voice_room_provider.dart';

/// Floating overlay gesture picker for speakers with cooldown visualization.
class GestureTrayWidget extends StatefulWidget {
  final VoidCallback onClose;

  const GestureTrayWidget({required this.onClose, super.key});

  static const List<({String id, String label, IconData icon})> gestures = [
    (id: 'wave', label: 'Wave', icon: Icons.waving_hand),
    (id: 'bow', label: 'Bow', icon: Icons.accessibility_new),
    (id: 'dance', label: 'Dance', icon: Icons.music_note),
    (id: 'jump', label: 'Jump', icon: Icons.arrow_upward),
    (id: 'clap', label: 'Clap', icon: Icons.volunteer_activism),
  ];

  @override
  State<GestureTrayWidget> createState() => _GestureTrayWidgetState();
}

class _GestureTrayWidgetState extends State<GestureTrayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _inactivityTimer;
  final Map<String, Timer> _cooldownTimers = {};
  bool _isClosing = false;

  /// Per-gesture cooldown progress from 0.0 (just sent) to 1.0 (ready).
  final Map<String, double> _cooldownProgress = {};
  final Map<String, double> _cooldownSecondsLeft = {};

  static const _autoCloseDuration = Duration(seconds: 5);
  static const _gestureCooldownMs = 3000; // must match provider's 3s

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animController.forward();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    for (final timer in _cooldownTimers.values) {
      timer.cancel();
    }
    _cooldownTimers.clear();
    _animController.dispose();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_autoCloseDuration, _animateClose);
  }

  void _animateClose() {
    if (_isClosing) return;
    _isClosing = true;
    _inactivityTimer?.cancel();
    _animController.reverse().then((_) {
      if (mounted) widget.onClose();
    });
  }

  void _startCooldownVisualization(String gestureId) {
    _cooldownTimers[gestureId]?.cancel();
    final startTime = DateTime.now();

    setState(() {
      _cooldownProgress[gestureId] = 0.0;
      _cooldownSecondsLeft[gestureId] = _gestureCooldownMs / 1000.0;
    });

    _cooldownTimers[gestureId] = Timer.periodic(const Duration(milliseconds: 80), (_) {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final progress = (elapsed / _gestureCooldownMs).clamp(0.0, 1.0);

      if (!mounted) {
        _cooldownTimers[gestureId]?.cancel();
        _cooldownTimers.remove(gestureId);
        return;
      }

      setState(() {
        _cooldownProgress[gestureId] = progress;
        _cooldownSecondsLeft[gestureId] =
            ((_gestureCooldownMs - elapsed) / 1000.0).clamp(0.0, 3.0);
      });

      if (progress >= 1.0) {
        _cooldownTimers[gestureId]?.cancel();
        _cooldownTimers.remove(gestureId);
      }
    });
  }

  void _onGestureTap(String gestureId) {
    final provider = context.read<VoiceRoomProvider>();
    if (!provider.isSpeaker || !provider.canSendGesture(gestureId)) return;

    provider.sendGesture(gestureId);
    _resetInactivityTimer();
    _startCooldownVisualization(gestureId);
  }

  /// Resolve gesture label using l10n, falling back to the static English label.
  String _resolvedGestureLabel(AppLocalizations? l10n, String id, String fallback) {
    if (l10n == null) return fallback;
    switch (id) {
      case 'wave':
        return l10n.voiceRoomGestureWave;
      case 'bow':
        return l10n.voiceRoomGestureBow;
      case 'dance':
        return l10n.voiceRoomGestureDance;
      case 'jump':
        return l10n.voiceRoomGestureJump;
      case 'clap':
        return l10n.voiceRoomGestureClap;
      default:
        return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<VoiceRoomProvider>(
      builder: (context, provider, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Material(
                elevation: 8,
                color: const Color(0xFF1A2744),
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...GestureTrayWidget.gestures.map((g) {
                        final canSend = provider.canSendGesture(g.id);
                        final gProgress = _cooldownProgress[g.id] ?? 1.0;
                        final gSecondsLeft = _cooldownSecondsLeft[g.id] ?? 0.0;

                        // If provider says ready but our visual hasn't caught up, sync.
                        if (canSend && gProgress < 1.0) {
                          _cooldownTimers[g.id]?.cancel();
                          _cooldownTimers.remove(g.id);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _cooldownProgress[g.id] = 1.0;
                                _cooldownSecondsLeft[g.id] = 0.0;
                              });
                            }
                          });
                        }

                        final localizedLabel = _resolvedGestureLabel(l10n, g.id, g.label);
                        return Semantics(
                          button: true,
                          label: l10n?.voiceRoomPerformGesture(localizedLabel.toLowerCase()) ??
                              'Perform ${g.label.toLowerCase()} gesture',
                          enabled: canSend,
                          child: InkWell(
                            onTap: canSend
                                ? () => _onGestureTap(g.id)
                                : null,
                            borderRadius: BorderRadius.circular(24),
                            splashColor: Colors.purple.withValues(alpha: 0.3),
                            highlightColor:
                                Colors.purple.withValues(alpha: 0.1),
                            child: SizedBox(
                              width: 56,
                              height: 64,
                              child: ExcludeSemantics(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    _buildGestureIcon(g, canSend, gProgress),
                                    const SizedBox(height: 2),
                                    Text(
                                      !canSend
                                          ? '${gSecondsLeft.toStringAsFixed(1)}s'
                                          : localizedLabel,
                                      style: TextStyle(
                                        color: canSend
                                            ? Colors.white60
                                            : Colors.amber.shade300,
                                        fontSize: 11,
                                        fontWeight: canSend
                                            ? FontWeight.normal
                                            : FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(width: 4),
                      Semantics(
                        button: true,
                        label: l10n?.voiceRoomCloseGestureTray ?? 'Close gesture tray',
                        child: InkWell(
                          onTap: _animateClose,
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.close,
                              color: Colors.white.withValues(alpha: 0.4),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGestureIcon(
    ({String id, String label, IconData icon}) gesture,
    bool canSend,
    double progress,
  ) {
    const double iconContainerSize = 40.0;

    if (!canSend) {
      // Show circular progress indicator around the icon during cooldown.
      return SizedBox(
        width: iconContainerSize,
        height: iconContainerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: iconContainerSize,
              height: iconContainerSize,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 2.5,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.amber.shade400),
              ),
            ),
            Icon(
              gesture.icon,
              color: Colors.grey.shade500,
              size: 18,
            ),
          ],
        ),
      );
    }

    return Container(
      width: iconContainerSize,
      height: iconContainerSize,
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        gesture.icon,
        color: Colors.purple.shade200,
        size: 20,
      ),
    );
  }
}
