import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Recording state enum
enum RecordingState {
  idle,
  recording,
  recorded,
  playing,
}

/// Recording widget for pronunciation practice
/// Only functional on mobile platforms (iOS/Android)
class RecordingWidget extends StatefulWidget {
  final String targetCharacter;
  final String? nativeAudioUrl;
  final Function(String recordingPath)? onRecordingComplete;
  final VoidCallback? onPlayNative;

  const RecordingWidget({
    required this.targetCharacter,
    this.nativeAudioUrl,
    this.onRecordingComplete,
    this.onPlayNative,
    super.key,
  });

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget>
    with SingleTickerProviderStateMixin {
  RecordingState _state = RecordingState.idle;
  String? _recordingPath;
  late AnimationController _pulseController;
  Duration _recordingDuration = Duration.zero;
  bool _isSupported = false;
  bool _hasPermission = false;

  // Recording and playback
  AudioRecorder? _recorder;
  just_audio.AudioPlayer? _player;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Check platform support and initialize
    _initRecording();
  }

  Future<void> _initRecording() async {
    // Recording is only supported on mobile platforms
    _isSupported = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

    if (_isSupported) {
      _recorder = AudioRecorder();
      _player = just_audio.AudioPlayer();

      // Check for permission
      await _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final status = await Permission.microphone.status;
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    final granted = status.isGranted;
    setState(() {
      _hasPermission = granted;
    });
    return granted;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _recorder?.dispose();
    _player?.dispose();
    // Clean up recording file
    if (_recordingPath != null) {
      File(_recordingPath!).delete().ignore();
    }
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!_isSupported || _recorder == null) return;

    // Request permission if not granted
    if (!_hasPermission) {
      final granted = await _requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.microphonePermissionRequired),
              action: SnackBarAction(
                label: AppLocalizations.of(context)!.settings,
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }
    }

    try {
      // Get temp directory for recording
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _recordingPath = '${tempDir.path}/recording_$timestamp.m4a';

      // Configure and start recording
      await _recorder!.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordingPath!,
      );

      setState(() {
        _state = RecordingState.recording;
        _recordingDuration = Duration.zero;
      });
      _pulseController.repeat(reverse: true);

      // Track recording duration
      _trackRecordingDuration();
    } catch (e) {
      debugPrint('[RecordingWidget] Failed to start recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start recording: $e')),
        );
      }
    }
  }

  void _trackRecordingDuration() async {
    while (_state == RecordingState.recording) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_state == RecordingState.recording && mounted) {
        setState(() {
          _recordingDuration += const Duration(milliseconds: 100);
        });

        // Auto-stop after 10 seconds
        if (_recordingDuration.inSeconds >= 10) {
          _stopRecording();
          break;
        }
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isSupported || _recorder == null) return;

    _pulseController.stop();
    _pulseController.reset();

    try {
      final path = await _recorder!.stop();
      if (path != null && mounted) {
        setState(() {
          _state = RecordingState.recorded;
          _recordingPath = path;
        });
        widget.onRecordingComplete?.call(path);
      }
    } catch (e) {
      debugPrint('[RecordingWidget] Failed to stop recording: $e');
      setState(() {
        _state = RecordingState.idle;
        _recordingPath = null;
      });
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath == null || _player == null) return;

    try {
      setState(() => _state = RecordingState.playing);

      await _player!.setFilePath(_recordingPath!);
      await _player!.play();

      // Wait for playback to complete
      await _player!.playerStateStream.firstWhere(
        (state) => state.processingState == just_audio.ProcessingState.completed,
      );

      if (mounted) {
        setState(() => _state = RecordingState.recorded);
      }
    } catch (e) {
      debugPrint('[RecordingWidget] Failed to play recording: $e');
      if (mounted) {
        setState(() => _state = RecordingState.recorded);
      }
    }
  }

  Future<void> _stopPlayback() async {
    await _player?.stop();
    if (mounted) {
      setState(() => _state = RecordingState.recorded);
    }
  }

  void _resetRecording() {
    // Delete old recording file
    if (_recordingPath != null) {
      File(_recordingPath!).delete().ignore();
    }

    setState(() {
      _state = RecordingState.idle;
      _recordingPath = null;
      _recordingDuration = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_isSupported) {
      return _buildNotSupportedView(l10n);
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.mic,
                color: Colors.red.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.recordPronunciation,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Target character
          Center(
            child: Text(
              widget.targetCharacter,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recording controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Play native audio button
              if (widget.nativeAudioUrl != null)
                IconButton(
                  onPressed: widget.onPlayNative,
                  icon: const Icon(Icons.hearing),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade700,
                  ),
                  tooltip: l10n.compareWithNative,
                ),

              const SizedBox(width: 16),

              // Main record button
              _buildRecordButton(),

              const SizedBox(width: 16),

              // Play recording button
              if (_state == RecordingState.recorded ||
                  _state == RecordingState.playing)
                IconButton(
                  onPressed: _state == RecordingState.playing
                      ? _stopPlayback
                      : _playRecording,
                  icon: Icon(
                    _state == RecordingState.playing
                        ? Icons.stop
                        : Icons.play_arrow,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    foregroundColor: Colors.green.shade700,
                  ),
                  tooltip: l10n.playRecording,
                ),
            ],
          ),

          // Recording duration
          if (_state == RecordingState.recording)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Text(
                  _formatDuration(_recordingDuration),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ),

          // Self evaluation after recording
          if (_state == RecordingState.recorded) ...[
            const SizedBox(height: 16),
            _buildSelfEvaluation(l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildNotSupportedView(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.mic_off, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.recordingNotSupported,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordButton() {
    return GestureDetector(
      onTap: () {
        if (_state == RecordingState.idle) {
          _startRecording();
        } else if (_state == RecordingState.recording) {
          _stopRecording();
        } else if (_state == RecordingState.recorded) {
          _resetRecording();
        }
      },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = _state == RecordingState.recording
              ? 1.0 + (_pulseController.value * 0.1)
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getButtonColor(),
                boxShadow: _state == RecordingState.recording
                    ? [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _getButtonIcon(),
                size: 32,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getButtonColor() {
    switch (_state) {
      case RecordingState.idle:
        return Colors.red;
      case RecordingState.recording:
        return Colors.red.shade700;
      case RecordingState.recorded:
        return Colors.orange;
      case RecordingState.playing:
        return Colors.green;
    }
  }

  IconData _getButtonIcon() {
    switch (_state) {
      case RecordingState.idle:
        return Icons.mic;
      case RecordingState.recording:
        return Icons.stop;
      case RecordingState.recorded:
        return Icons.refresh;
      case RecordingState.playing:
        return Icons.volume_up;
    }
  }

  Widget _buildSelfEvaluation(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.selfEvaluation,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEvaluationButton(
                l10n.accurate,
                Icons.check_circle,
                Colors.green,
              ),
              _buildEvaluationButton(
                l10n.almostCorrect,
                Icons.check_circle_outline,
                Colors.orange,
              ),
              _buildEvaluationButton(
                l10n.needsPractice,
                Icons.refresh,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationButton(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        // Handle evaluation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: $label'),
            duration: const Duration(seconds: 1),
          ),
        );
        _resetRecording();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
