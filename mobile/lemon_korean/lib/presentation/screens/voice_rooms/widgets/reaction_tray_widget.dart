import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/voice_room_provider.dart';

/// Floating overlay emoji reaction picker with auto-close on inactivity.
class ReactionTrayWidget extends StatefulWidget {
  final VoidCallback onClose;

  const ReactionTrayWidget({required this.onClose, super.key});

  static const List<String> reactions = [
    '\u{1F44B}', // wave
    '\u{2764}', // heart
    '\u{1F44F}', // clap
    '\u{1F602}', // laugh
    '\u{1F44D}', // thumbs up
    '\u{1F525}', // fire
    '\u{1F60D}', // heart eyes
    '\u{1F389}', // party
  ];

  static const List<String> _reactionNames = [
    'wave',
    'heart',
    'clap',
    'laugh',
    'thumbs up',
    'fire',
    'love',
    'celebration',
  ];

  @override
  State<ReactionTrayWidget> createState() => _ReactionTrayWidgetState();
}

class _ReactionTrayWidgetState extends State<ReactionTrayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _inactivityTimer;
  bool _isClosing = false;

  static const _autoCloseDuration = Duration(seconds: 3);

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

  void _onReactionTap(String emoji) {
    if (!mounted) return;
    context.read<VoiceRoomProvider>().sendReaction(emoji);
    _resetInactivityTimer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Material(
            elevation: 8,
            color: const Color(0xFF1A2744),
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black54,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            ReactionTrayWidget.reactions.length, (index) {
                          final emoji = ReactionTrayWidget.reactions[index];
                          final name = ReactionTrayWidget._reactionNames[index];
                          return Semantics(
                            button: true,
                            label: l10n?.voiceRoomSendReactionNamed(name) ?? 'Send $name reaction',
                            child: InkWell(
                              onTap: () => _onReactionTap(emoji),
                              borderRadius: BorderRadius.circular(24),
                              splashColor: Colors.white24,
                              highlightColor: Colors.white10,
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Center(
                                  child: ExcludeSemantics(
                                    child: Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Semantics(
                    button: true,
                    label: l10n?.voiceRoomCloseReactionTray ?? 'Close reaction tray',
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
  }
}
