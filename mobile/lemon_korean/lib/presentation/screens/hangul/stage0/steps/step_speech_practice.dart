import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/korean_tts_helper.dart';
import '../../../../../data/models/speech_result_model.dart';
import '../../../../providers/speech_provider.dart';
import '../stage0_lesson_content.dart';

/// Speech practice step: record pronunciation and get AI feedback.
/// Models are bundled with the app — works fully offline.
class StepSpeechPractice extends StatefulWidget {
  final LessonStep step;
  final void Function(int correct, int total) onCompleted;

  const StepSpeechPractice({
    required this.step,
    required this.onCompleted,
    super.key,
  });

  @override
  State<StepSpeechPractice> createState() => _StepSpeechPracticeState();
}

class _StepSpeechPracticeState extends State<StepSpeechPractice>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  int _currentCharIndex = 0;
  int _currentAttempt = 0;
  int _correctCount = 0;
  int _totalCount = 0;
  bool _isPlayingTts = false;
  Duration _recordingDuration = Duration.zero;
  bool _trackingDuration = false;

  List<String> get _characters =>
      (widget.step.data['characters'] as List?)?.cast<String>() ?? [];
  int get _maxAttempts => widget.step.data['maxAttempts'] as int? ?? 3;
  int get _passScore => widget.step.data['passScore'] as int? ?? 70;
  bool get _showPhonemeDetail =>
      widget.step.data['showPhonemeDetail'] as bool? ?? true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpeechProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _currentChar =>
      _characters.isNotEmpty ? _characters[_currentCharIndex] : '';

  Future<void> _playSound() async {
    setState(() => _isPlayingTts = true);
    await KoreanTtsHelper.playKoreanText(_currentChar);
    if (mounted) setState(() => _isPlayingTts = false);
  }

  Future<void> _startRecording() async {
    final speech = context.read<SpeechProvider>();
    final started = await speech.startRecording();
    if (started) {
      _pulseController.repeat(reverse: true);
      _recordingDuration = Duration.zero;
      _trackingDuration = true;
      _trackDuration();
    }
  }

  void _trackDuration() async {
    while (_trackingDuration && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_trackingDuration && mounted) {
        setState(() {
          _recordingDuration += const Duration(milliseconds: 100);
        });
        if (_recordingDuration.inSeconds >= 10) {
          _stopAndAnalyze();
          break;
        }
      }
    }
  }

  Future<void> _stopAndAnalyze() async {
    _trackingDuration = false;
    _pulseController.stop();
    _pulseController.reset();

    final speech = context.read<SpeechProvider>();
    await speech.stopAndAnalyze(
      expectedText: _currentChar,
      language: 'ko',
    );

    _currentAttempt++;
    _totalCount++;

    final result = speech.lastResult;
    if (result != null && result.overallScore >= _passScore) {
      _correctCount++;
    }
  }

  void _retryOrNext({bool forceNext = false}) {
    final speech = context.read<SpeechProvider>();
    final result = speech.lastResult;
    final passed = result != null && result.overallScore >= _passScore;

    if (!forceNext && !passed && _currentAttempt < _maxAttempts) {
      speech.resetForNext();
      _recordingDuration = Duration.zero;
      setState(() {});
      return;
    }

    speech.resetForNext();
    _currentAttempt = 0;
    _recordingDuration = Duration.zero;

    if (_currentCharIndex < _characters.length - 1) {
      setState(() => _currentCharIndex++);
    } else {
      widget.onCompleted(_correctCount, _totalCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_characters.isEmpty) {
      return const Center(child: Text('No characters defined'));
    }

    return Consumer<SpeechProvider>(
      builder: (context, speech, _) {
        return _buildPracticeView(speech);
      },
    );
  }

  Widget _buildPracticeView(SpeechProvider speech) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Title + progress
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.step.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentCharIndex + 1}/${_characters.length}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (widget.step.description != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.step.description!,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
          const Spacer(),
          // Large character display
          GestureDetector(
            onTap: _playSound,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                shape: BoxShape.circle,
                border:
                    Border.all(color: const Color(0xFFFFD54F), width: 3),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    _currentChar,
                    style: const TextStyle(
                        fontSize: 56, fontWeight: FontWeight.bold),
                  ),
                  Positioned(
                    bottom: 8,
                    child: Icon(
                      _isPlayingTts
                          ? Icons.volume_up
                          : Icons.volume_up_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Record button or results
          if (speech.recordingState == SpeechRecordingState.idle)
            _buildRecordButton(speech)
          else if (speech.recordingState == SpeechRecordingState.recording)
            _buildRecordingView(speech)
          else if (speech.recordingState == SpeechRecordingState.processing)
            _buildProcessingView()
          else if (speech.recordingState == SpeechRecordingState.scored)
            _buildResultsView(speech),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildRecordButton(SpeechProvider speech) {
    return Column(
      children: [
        GestureDetector(
          onTap: _startRecording,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.mic, size: 32, color: Colors.white),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.0, 1.0),
              duration: 300.ms,
            ),
        const SizedBox(height: 8),
        Text(
          '탭하여 녹음',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildRecordingView(SpeechProvider speech) {
    return Column(
      children: [
        GestureDetector(
          onTap: _stopAndAnalyze,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1.0 + (_pulseController.value * 0.1);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade700,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.stop, size: 32, color: Colors.white),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatDuration(_recordingDuration),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Column(
      children: [
        const SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD54F)),
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '분석 중...',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildResultsView(SpeechProvider speech) {
    final result = speech.lastResult;
    if (result == null) return const SizedBox.shrink();

    final passed = result.overallScore >= _passScore;
    final canRetry = !passed && _currentAttempt < _maxAttempts;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildScoreDisplay(result),
            const SizedBox(height: 12),
            if (_showPhonemeDetail && result.phonemeScores.isNotEmpty)
              _buildPhonemeBreakdown(result),
            const SizedBox(height: 12),
            _buildAnalysisSummary(result),
            if (result.feedback.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildFeedback(result),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (canRetry)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _retryOrNext(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child:
                          Text('다시 시도 ($_currentAttempt/$_maxAttempts)'),
                    ),
                  ),
                if (canRetry) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _retryOrNext(forceNext: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD54F),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _currentCharIndex < _characters.length - 1
                          ? '다음'
                          : '완료',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(SpeechResult result) {
    final color = result.overallScore >= 90
        ? Colors.green
        : result.overallScore >= 70
            ? const Color(0xFFFFB300)
            : result.overallScore >= 50
                ? Colors.orange
                : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                '${result.overallScore}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < result.starRating
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color(0xFFFFD54F),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _gradeText(result.grade),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPhonemeBreakdown(SpeechResult result) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: result.phonemeScores.map((ps) {
        final color = ps.score >= 80
            ? Colors.green
            : ps.score >= 60
                ? Colors.orange
                : Colors.red;
        final icon = ps.score >= 80
            ? Icons.check_circle
            : ps.score >= 60
                ? Icons.change_history
                : Icons.cancel;

        return Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                ps.expected,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                '${ps.score}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnalysisSummary(SpeechResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields, size: 16, color: Colors.blue.shade400),
              const SizedBox(width: 6),
              Text(
                '인식: "${result.transcription}"',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const Spacer(),
              Text(
                result.transcription == result.expectedText ? '정확' : '',
                style: TextStyle(
                  fontSize: 12,
                  color: result.transcription == result.expectedText
                      ? Colors.green
                      : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.bar_chart, size: 16, color: Colors.purple.shade400),
              const SizedBox(width: 6),
              Text(
                '발음 품질: ${result.gopScore}점',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback(SpeechResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 16, color: Color(0xFFF9A825)),
              SizedBox(width: 6),
              Text(
                '피드백',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9A825),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...result.feedback.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  f,
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey.shade800),
                ),
              )),
        ],
      ),
    );
  }

  String _gradeText(String grade) {
    switch (grade) {
      case 'excellent':
        return '훌륭해요!';
      case 'good':
        return '잘했어요!';
      case 'fair':
        return '괜찮아요!';
      default:
        return '더 연습해요!';
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
