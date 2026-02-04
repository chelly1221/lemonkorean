import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/hangul_provider.dart';
import 'widgets/pronunciation_player.dart';

/// Similar sound groups for discrimination training
class SimilarSoundGroup {
  final String name;
  final String nameKo;
  final String description;
  final List<String> characters;
  final String category; // 'consonant' or 'vowel'

  const SimilarSoundGroup({
    required this.name,
    required this.nameKo,
    required this.description,
    required this.characters,
    required this.category,
  });

  static const List<SimilarSoundGroup> consonantGroups = [
    SimilarSoundGroup(
      name: 'ㄱ/ㅋ/ㄲ',
      nameKo: '기역 계열',
      description: '평음/격음/경음',
      characters: ['ㄱ', 'ㅋ', 'ㄲ'],
      category: 'consonant',
    ),
    SimilarSoundGroup(
      name: 'ㄷ/ㅌ/ㄸ',
      nameKo: '디귿 계열',
      description: '평음/격음/경음',
      characters: ['ㄷ', 'ㅌ', 'ㄸ'],
      category: 'consonant',
    ),
    SimilarSoundGroup(
      name: 'ㅂ/ㅍ/ㅃ',
      nameKo: '비읍 계열',
      description: '평음/격음/경음',
      characters: ['ㅂ', 'ㅍ', 'ㅃ'],
      category: 'consonant',
    ),
    SimilarSoundGroup(
      name: 'ㅈ/ㅊ/ㅉ',
      nameKo: '지읒 계열',
      description: '평음/격음/경음',
      characters: ['ㅈ', 'ㅊ', 'ㅉ'],
      category: 'consonant',
    ),
    SimilarSoundGroup(
      name: 'ㅅ/ㅆ',
      nameKo: '시옷 계열',
      description: '평음/경음',
      characters: ['ㅅ', 'ㅆ'],
      category: 'consonant',
    ),
  ];

  static const List<SimilarSoundGroup> vowelGroups = [
    SimilarSoundGroup(
      name: 'ㅓ/ㅗ',
      nameKo: '어/오',
      description: '입 모양이 비슷함',
      characters: ['ㅓ', 'ㅗ'],
      category: 'vowel',
    ),
    SimilarSoundGroup(
      name: 'ㅡ/ㅜ',
      nameKo: '으/우',
      description: '입술 모양 차이',
      characters: ['ㅡ', 'ㅜ'],
      category: 'vowel',
    ),
    SimilarSoundGroup(
      name: 'ㅐ/ㅔ',
      nameKo: '애/에',
      description: '현대 한국어에서 거의 동일',
      characters: ['ㅐ', 'ㅔ'],
      category: 'vowel',
    ),
    SimilarSoundGroup(
      name: 'ㅚ/ㅙ/ㅞ',
      nameKo: '외/왜/웨',
      description: '현대 한국어에서 거의 동일',
      characters: ['ㅚ', 'ㅙ', 'ㅞ'],
      category: 'vowel',
    ),
  ];
}

/// Sound discrimination training screen
class HangulDiscriminationScreen extends StatefulWidget {
  final SimilarSoundGroup? initialGroup;

  const HangulDiscriminationScreen({
    this.initialGroup,
    super.key,
  });

  @override
  State<HangulDiscriminationScreen> createState() =>
      _HangulDiscriminationScreenState();
}

class _HangulDiscriminationScreenState
    extends State<HangulDiscriminationScreen> {
  SimilarSoundGroup? _selectedGroup;
  bool _inPractice = false;
  int _currentQuestionIndex = 0;
  int _correctCount = 0;
  final int _totalQuestions = 10;
  List<_DiscriminationQuestion> _questions = [];
  String? _selectedAnswer;
  bool _showResult = false;
  PlaybackSpeed _playbackSpeed = PlaybackSpeed.normal;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _selectedGroup = widget.initialGroup;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startPractice(SimilarSoundGroup group) {
    _selectedGroup = group;
    _questions = _generateQuestions(group);
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _selectedAnswer = null;
    _showResult = false;

    setState(() {
      _inPractice = true;
    });

    // Auto-play first question
    _playCurrentSound();
  }

  List<_DiscriminationQuestion> _generateQuestions(SimilarSoundGroup group) {
    final random = Random();
    final questions = <_DiscriminationQuestion>[];

    for (int i = 0; i < _totalQuestions; i++) {
      final correctChar = group.characters[random.nextInt(group.characters.length)];
      questions.add(_DiscriminationQuestion(
        correctAnswer: correctChar,
        options: List.from(group.characters)..shuffle(random),
      ));
    }

    return questions;
  }

  Future<void> _playCurrentSound() async {
    if (_currentQuestionIndex >= _questions.length) return;

    final question = _questions[_currentQuestionIndex];
    final provider = Provider.of<HangulProvider>(context, listen: false);
    final character = provider.findCharacterByChar(question.correctAnswer);

    if (character?.hasAudio == true) {
      try {
        final audioUrl = '${AppConstants.mediaUrl}/${character!.audioUrl}';
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.setSpeed(_playbackSpeed.value);
        await _audioPlayer.play();
      } catch (e) {
        debugPrint('[DiscriminationScreen] Audio error: $e');
      }
    }
  }

  void _submitAnswer(String answer) {
    if (_showResult) return;

    final question = _questions[_currentQuestionIndex];
    final isCorrect = answer == question.correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
      _playCurrentSound();
    } else {
      // Practice complete
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final l10n = AppLocalizations.of(context)!;
    final percentage = (_correctCount / _totalQuestions * 100).toInt();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.practiceComplete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Score circle
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _correctCount / _totalQuestions,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage >= 80
                          ? Colors.green
                          : percentage >= 60
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_correctCount/$_totalQuestions',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 80
                  ? l10n.excellent
                  : percentage >= 60
                      ? l10n.greatJob
                      : l10n.keepPracticing,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _inPractice = false;
              });
            },
            child: Text(l10n.back),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startPractice(_selectedGroup!);
            },
            child: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.soundDiscrimination),
        actions: [
          if (_inPractice)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentQuestionIndex + 1}/$_totalQuestions',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _inPractice ? _buildPracticeView() : _buildGroupSelectionView(),
    );
  }

  Widget _buildGroupSelectionView() {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.listenAndSelect,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Consonant groups
          Text(
            '${l10n.similarSoundGroups} - ${l10n.basicConsonants}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...SimilarSoundGroup.consonantGroups
              .map((group) => _buildGroupCard(group)),

          const SizedBox(height: 24),

          // Vowel groups
          Text(
            '${l10n.similarSoundGroups} - ${l10n.basicVowels}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...SimilarSoundGroup.vowelGroups.map((group) => _buildGroupCard(group)),
        ],
      ),
    );
  }

  Widget _buildGroupCard(SimilarSoundGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _startPractice(group),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Character preview
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: group.category == 'consonant'
                      ? Colors.blue.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: group.category == 'consonant'
                          ? Colors.blue.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.nameKo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_arrow,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPracticeView() {
    final l10n = AppLocalizations.of(context)!;
    final question = _questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _totalQuestions,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
            ),
          ),

          const SizedBox(height: 24),

          // Speed control
          _buildSpeedControl(),

          const SizedBox(height: 24),

          // Play button
          GestureDetector(
            onTap: _playCurrentSound,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.volume_up,
                size: 60,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            l10n.listenAndSelect,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 32),

          // Answer options
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: question.options.length > 2 ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                final option = question.options[index];
                return _buildOptionButton(option, question.correctAnswer);
              },
            ),
          ),

          // Next button
          if (_showResult)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentQuestionIndex < _questions.length - 1
                        ? l10n.nextQuestion
                        : l10n.viewResults,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
                onTap: () {
                  setState(() => _playbackSpeed = speed);
                  _audioPlayer.setSpeed(speed.value);
                },
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
                      color: isSelected ? Colors.black87 : Colors.grey.shade700,
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

  Widget _buildOptionButton(String option, String correctAnswer) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (_showResult) {
      if (option == correctAnswer) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
        textColor = Colors.green.shade900;
      } else if (option == _selectedAnswer) {
        backgroundColor = Colors.red.shade100;
        borderColor = Colors.red;
        textColor = Colors.red.shade900;
      } else {
        backgroundColor = Colors.grey.shade100;
        borderColor = Colors.grey.shade300;
        textColor = Colors.grey.shade600;
      }
    } else {
      backgroundColor =
          option == _selectedAnswer ? Colors.blue.shade100 : Colors.white;
      borderColor =
          option == _selectedAnswer ? Colors.blue : Colors.grey.shade300;
      textColor = Colors.black87;
    }

    return InkWell(
      onTap: _showResult ? null : () => _submitAnswer(option),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (_showResult && option == correctAnswer)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
              if (_showResult &&
                  option == _selectedAnswer &&
                  option != correctAnswer)
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscriminationQuestion {
  final String correctAnswer;
  final List<String> options;

  _DiscriminationQuestion({
    required this.correctAnswer,
    required this.options,
  });
}
