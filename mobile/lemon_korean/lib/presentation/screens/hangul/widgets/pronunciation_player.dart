import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/hangul_character_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Playback speed options
enum PlaybackSpeed {
  slow(0.5, '0.5x'),
  normal75(0.75, '0.75x'),
  normal(1.0, '1x');

  const PlaybackSpeed(this.value, this.label);
  final double value;
  final String label;
}

/// Pronunciation Player Widget
/// Displays pronunciation guide with speed control and repeat functionality
class PronunciationPlayer extends StatefulWidget {
  final HangulCharacterModel character;
  final bool autoPlay;
  final bool showSpeedControl;
  final bool showRepeatControl;

  const PronunciationPlayer({
    required this.character,
    this.autoPlay = false,
    this.showSpeedControl = true,
    this.showRepeatControl = true,
    super.key,
  });

  @override
  State<PronunciationPlayer> createState() => _PronunciationPlayerState();
}

class _PronunciationPlayerState extends State<PronunciationPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _repeatEnabled = false;
  PlaybackSpeed _currentSpeed = PlaybackSpeed.normal;
  int _repeatCount = 0;
  static const int _maxRepeats = 3;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();

    if (widget.autoPlay && widget.character.hasAudio) {
      _playAudio();
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _onPlaybackComplete();
      }
    });
  }

  void _onPlaybackComplete() {
    if (_repeatEnabled && _repeatCount < _maxRepeats - 1) {
      _repeatCount++;
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.play();
    } else {
      _repeatCount = 0;
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _playAudio() async {
    if (!widget.character.hasAudio || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final audioUrl = '${AppConstants.mediaUrl}/${widget.character.audioUrl}';
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.setSpeed(_currentSpeed.value);
      _repeatCount = 0;
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('[PronunciationPlayer] Error playing audio: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    _repeatCount = 0;
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _changeSpeed(PlaybackSpeed speed) async {
    setState(() {
      _currentSpeed = speed;
    });
    await _audioPlayer.setSpeed(speed.value);
  }

  void _toggleRepeat() {
    setState(() {
      _repeatEnabled = !_repeatEnabled;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
          // Header with controls
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
              // Audio controls
              if (widget.character.hasAudio) ...[
                // Repeat toggle
                if (widget.showRepeatControl)
                  IconButton(
                    onPressed: _toggleRepeat,
                    icon: Icon(
                      _repeatEnabled ? Icons.repeat_one : Icons.repeat,
                      color: _repeatEnabled
                          ? AppConstants.primaryColor
                          : Colors.grey.shade600,
                      size: 20,
                    ),
                    tooltip: _repeatEnabled
                        ? l10n.repeatEnabled
                        : l10n.repeatDisabled,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                // Play/Stop button
                IconButton(
                  onPressed: _isLoading
                      ? null
                      : (_isPlaying ? _stopAudio : _playAudio),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _isPlaying
                              ? Icons.stop_circle
                              : Icons.play_circle_outline,
                          color: _isPlaying
                              ? Colors.red
                              : AppConstants.infoColor,
                        ),
                  tooltip: _isPlaying ? l10n.stop : l10n.playPronunciation,
                ),
              ],
            ],
          ),

          // Speed control
          if (widget.character.hasAudio && widget.showSpeedControl) ...[
            const SizedBox(height: 8),
            _buildSpeedControl(),
          ],

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

          // Repeat indicator
          if (_isPlaying && _repeatEnabled) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.repeat,
                  size: 14,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_repeatCount + 1}/$_maxRepeats',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeedControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.speed,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          ...PlaybackSpeed.values.map((speed) => _buildSpeedButton(speed)),
        ],
      ),
    );
  }

  Widget _buildSpeedButton(PlaybackSpeed speed) {
    final isSelected = _currentSpeed == speed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () => _changeSpeed(speed),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppConstants.primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            speed.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact pronunciation player for use in lists or cards
class CompactPronunciationPlayer extends StatefulWidget {
  final HangulCharacterModel character;
  final PlaybackSpeed initialSpeed;

  const CompactPronunciationPlayer({
    required this.character,
    this.initialSpeed = PlaybackSpeed.normal,
    super.key,
  });

  @override
  State<CompactPronunciationPlayer> createState() =>
      _CompactPronunciationPlayerState();
}

class _CompactPronunciationPlayerState
    extends State<CompactPronunciationPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  PlaybackSpeed _currentSpeed = PlaybackSpeed.normal;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentSpeed = widget.initialSpeed;

    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
      }
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    } else if (widget.character.hasAudio) {
      try {
        final audioUrl =
            '${AppConstants.mediaUrl}/${widget.character.audioUrl}';
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.setSpeed(_currentSpeed.value);
        await _audioPlayer.play();
      } catch (e) {
        debugPrint('[CompactPronunciationPlayer] Error: $e');
      }
    }
  }

  void _cycleSpeed() {
    final speeds = PlaybackSpeed.values;
    final currentIndex = speeds.indexOf(_currentSpeed);
    final nextIndex = (currentIndex + 1) % speeds.length;
    setState(() {
      _currentSpeed = speeds[nextIndex];
    });
    _audioPlayer.setSpeed(_currentSpeed.value);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.character.hasAudio) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speed indicator (tap to cycle)
        GestureDetector(
          onTap: _cycleSpeed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _currentSpeed.label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Play button
        IconButton(
          onPressed: _togglePlayback,
          icon: Icon(
            _isPlaying ? Icons.stop : Icons.volume_up,
            size: 20,
            color: _isPlaying ? Colors.red : AppConstants.infoColor,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ],
    );
  }
}
