import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/hangul_character_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/hangul_provider.dart';
import 'widgets/pronunciation_player.dart';
import 'widgets/recording_widget.dart';

/// Shadowing practice mode
enum ShadowingStep {
  listen,
  record,
  compare,
  evaluate,
}

/// Shadowing practice screen
class HangulShadowingScreen extends StatefulWidget {
  final List<HangulCharacterModel>? characters;

  const HangulShadowingScreen({
    this.characters,
    super.key,
  });

  @override
  State<HangulShadowingScreen> createState() => _HangulShadowingScreenState();
}

class _HangulShadowingScreenState extends State<HangulShadowingScreen> {
  late List<HangulCharacterModel> _characters;
  int _currentIndex = 0;
  ShadowingStep _currentStep = ShadowingStep.listen;
  late AudioPlayer _audioPlayer;
  PlaybackSpeed _playbackSpeed = PlaybackSpeed.normal;
  bool _isPlaying = false;
  int _correctCount = 0;
  int _almostCount = 0;
  int _practiceCount = 0;
  bool _isSupported = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _isSupported = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

    // Initialize characters
    if (widget.characters != null && widget.characters!.isNotEmpty) {
      _characters = widget.characters!;
    } else {
      // Load from provider after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCharacters();
      });
      _characters = [];
    }
  }

  void _loadCharacters() {
    final provider = Provider.of<HangulProvider>(context, listen: false);
    final allChars = provider.allCharacters;
    if (allChars.isNotEmpty) {
      setState(() {
        _characters = allChars.where((c) => c.hasAudio).take(10).toList();
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  HangulCharacterModel? get _currentCharacter {
    if (_characters.isEmpty || _currentIndex >= _characters.length) return null;
    return _characters[_currentIndex];
  }

  Future<void> _playNativeAudio() async {
    final character = _currentCharacter;
    if (character == null || !character.hasAudio) return;

    setState(() => _isPlaying = true);

    try {
      final audioUrl = '${AppConstants.mediaUrl}/${character.audioUrl}';
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.setSpeed(_playbackSpeed.value);
      await _audioPlayer.play();
      await _audioPlayer.processingStateStream
          .firstWhere((s) => s == ProcessingState.completed);
    } catch (e) {
      debugPrint('[ShadowingScreen] Audio error: $e');
    }

    if (mounted) {
      setState(() {
        _isPlaying = false;
        // Auto-advance to record step after listening
        if (_currentStep == ShadowingStep.listen) {
          _currentStep = ShadowingStep.record;
        }
      });
    }
  }

  void _onRecordingComplete(String path) {
    setState(() {
      _recordingPath = path;
      _currentStep = ShadowingStep.compare;
    });
  }

  void _onEvaluate(String evaluation) {
    setState(() {
      switch (evaluation) {
        case 'accurate':
          _correctCount++;
          break;
        case 'almost':
          _almostCount++;
          break;
        case 'practice':
          _practiceCount++;
          break;
      }

      // Move to next character or finish
      if (_currentIndex < _characters.length - 1) {
        _currentIndex++;
        _currentStep = ShadowingStep.listen;
        _recordingPath = null;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    final l10n = AppLocalizations.of(context)!;
    final total = _correctCount + _almostCount + _practiceCount;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.practiceComplete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Results breakdown
            _buildResultRow(l10n.accurate, _correctCount, Colors.green),
            const SizedBox(height: 8),
            _buildResultRow(l10n.almostCorrect, _almostCount, Colors.orange),
            const SizedBox(height: 8),
            _buildResultRow(l10n.needsPractice, _practiceCount, Colors.red),
            const Divider(height: 24),
            Text(
              'Total: $total characters practiced',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.finish),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetPractice();
            },
            child: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(label),
      ],
    );
  }

  void _resetPractice() {
    setState(() {
      _currentIndex = 0;
      _currentStep = ShadowingStep.listen;
      _recordingPath = null;
      _correctCount = 0;
      _almostCount = 0;
      _practiceCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shadowingMode),
        actions: [
          if (_characters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1}/${_characters.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: _characters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : !_isSupported
              ? _buildNotSupportedView(l10n)
              : _buildShadowingView(),
    );
  }

  Widget _buildNotSupportedView(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.recordingNotSupported,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.back),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowingView() {
    final l10n = AppLocalizations.of(context)!;
    final character = _currentCharacter;

    if (character == null) {
      return const Center(child: Text('No characters available'));
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _characters.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
            ),
          ),

          const SizedBox(height: 16),

          // Step indicator
          _buildStepIndicator(l10n),

          const SizedBox(height: 24),

          // Character display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Text(
                  character.character,
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  character.romanization,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Step content
          Expanded(
            child: _buildStepContent(l10n, character),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepChip(
          '1. ${l10n.play}',
          _currentStep == ShadowingStep.listen,
          _currentStep.index >= ShadowingStep.listen.index,
        ),
        _buildStepConnector(_currentStep.index >= ShadowingStep.record.index),
        _buildStepChip(
          '2. ${l10n.startRecording}',
          _currentStep == ShadowingStep.record,
          _currentStep.index >= ShadowingStep.record.index,
        ),
        _buildStepConnector(_currentStep.index >= ShadowingStep.compare.index),
        _buildStepChip(
          '3. ${l10n.selfEvaluation}',
          _currentStep == ShadowingStep.compare ||
              _currentStep == ShadowingStep.evaluate,
          _currentStep.index >= ShadowingStep.compare.index,
        ),
      ],
    );
  }

  Widget _buildStepChip(String label, bool isActive, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppConstants.primaryColor
            : isCompleted
                ? Colors.green.shade100
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive
              ? Colors.black87
              : isCompleted
                  ? Colors.green.shade800
                  : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildStepConnector(bool isCompleted) {
    return Container(
      width: 16,
      height: 2,
      color: isCompleted ? Colors.green : Colors.grey.shade300,
    );
  }

  Widget _buildStepContent(AppLocalizations l10n, HangulCharacterModel character) {
    switch (_currentStep) {
      case ShadowingStep.listen:
        return _buildListenStep(l10n, character);
      case ShadowingStep.record:
        return _buildRecordStep(l10n, character);
      case ShadowingStep.compare:
      case ShadowingStep.evaluate:
        return _buildEvaluateStep(l10n, character);
    }
  }

  Widget _buildListenStep(AppLocalizations l10n, HangulCharacterModel character) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.listenThenRepeat,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),

        // Speed control
        _buildSpeedControl(),

        const SizedBox(height: 24),

        // Play button
        GestureDetector(
          onTap: _isPlaying ? null : _playNativeAudio,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _isPlaying ? Colors.grey : AppConstants.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isPlaying ? Colors.grey : AppConstants.primaryColor)
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              _isPlaying ? Icons.volume_up : Icons.play_arrow,
              size: 48,
              color: Colors.black87,
            ),
          ),
        ),

        if (_isPlaying)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              l10n.playingAudio,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecordStep(AppLocalizations l10n, HangulCharacterModel character) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.listenThenRepeat,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),

        // Listen again button
        TextButton.icon(
          onPressed: _playNativeAudio,
          icon: const Icon(Icons.hearing),
          label: Text(l10n.playPronunciation),
        ),

        const SizedBox(height: 24),

        // Recording widget
        RecordingWidget(
          targetCharacter: character.character,
          nativeAudioUrl: character.audioUrl,
          onRecordingComplete: _onRecordingComplete,
          onPlayNative: _playNativeAudio,
        ),
      ],
    );
  }

  Widget _buildEvaluateStep(AppLocalizations l10n, HangulCharacterModel character) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.selfEvaluation,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),

        // Comparison buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play native
            _buildCompareButton(
              l10n.compareWithNative,
              Icons.hearing,
              Colors.blue,
              _playNativeAudio,
            ),
            const SizedBox(width: 16),
            // Play recording
            _buildCompareButton(
              l10n.playRecording,
              Icons.mic,
              Colors.red,
              () {
                // Play recorded audio
              },
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Evaluation buttons
        Text(
          l10n.selfEvaluation,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEvaluationButton(
              l10n.accurate,
              Icons.check_circle,
              Colors.green,
              () => _onEvaluate('accurate'),
            ),
            _buildEvaluationButton(
              l10n.almostCorrect,
              Icons.check_circle_outline,
              Colors.orange,
              () => _onEvaluate('almost'),
            ),
            _buildEvaluationButton(
              l10n.needsPractice,
              Icons.refresh,
              Colors.red,
              () => _onEvaluate('practice'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.speed, size: 18),
          const SizedBox(width: 8),
          ...PlaybackSpeed.values.map((speed) {
            final isSelected = _playbackSpeed == speed;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => setState(() => _playbackSpeed = speed),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    speed.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCompareButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
