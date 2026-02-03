import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/hangul_character_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Pronunciation Player Widget
/// Displays pronunciation guide and plays audio if available
class PronunciationPlayer extends StatefulWidget {
  final HangulCharacterModel character;
  final bool autoPlay;

  const PronunciationPlayer({
    required this.character,
    this.autoPlay = false,
    super.key,
  });

  @override
  State<PronunciationPlayer> createState() => _PronunciationPlayerState();
}

class _PronunciationPlayerState extends State<PronunciationPlayer> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && widget.character.hasAudio) {
      _playAudio();
    }
  }

  Future<void> _playAudio() async {
    if (!widget.character.hasAudio || _isPlaying) return;

    setState(() => _isPlaying = true);

    try {
      // TODO: Implement audio playback using audioplayers or just_audio
      // final audioUrl = '${AppConstants.mediaUrl}/${widget.character.audioUrl}';
      // await audioPlayer.play(UrlSource(audioUrl));

      // Simulate playback for now
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('[PronunciationPlayer] Error playing audio: $e');
    }

    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.record_voice_over,
                color: Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.pronunciationGuide,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              // Audio button
              if (widget.character.hasAudio)
                IconButton(
                  onPressed: _isPlaying ? null : _playAudio,
                  icon: Icon(
                    _isPlaying ? Icons.volume_up : Icons.play_circle_outline,
                    color: _isPlaying
                        ? AppConstants.primaryColor
                        : AppConstants.infoColor,
                  ),
                  tooltip: l10n.playPronunciation,
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Romanization
          Row(
            children: [
              Text(
                l10n.romanization,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                ),
              ),
              Text(
                widget.character.romanization,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.infoColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Chinese pronunciation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.pronunciationLabel,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondary,
                ),
              ),
              Expanded(
                child: Text(
                  widget.character.pronunciationZh,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Pronunciation tip if available
          if (widget.character.hasTip) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.character.pronunciationTipZh!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
