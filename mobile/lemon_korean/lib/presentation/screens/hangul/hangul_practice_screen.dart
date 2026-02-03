import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/hangul_character_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hangul_provider.dart';

/// Hangul Practice Screen
/// Quiz/practice mode for Korean alphabet with SRS review
class HangulPracticeScreen extends StatefulWidget {
  const HangulPracticeScreen({super.key});

  @override
  State<HangulPracticeScreen> createState() => _HangulPracticeScreenState();
}

class _HangulPracticeScreenState extends State<HangulPracticeScreen> {
  PracticeMode _practiceMode = PracticeMode.recognition;
  bool _isLoading = true;
  bool _sessionActive = false;
  int _currentIndex = 0;
  bool _answered = false;
  int? _selectedOptionIndex;
  bool _isCorrect = false;

  List<HangulCharacterModel> _practiceQueue = [];
  List<HangulCharacterModel> _options = [];
  int _correctCount = 0;
  int _wrongCount = 0;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _loadPracticeQueue();
  }

  Future<void> _loadPracticeQueue() async {
    setState(() => _isLoading = true);

    final provider = Provider.of<HangulProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Load characters and review queue
    if (provider.characters.isEmpty) {
      await provider.loadAlphabetTable();
    }

    if (authProvider.currentUser != null) {
      await provider.loadReviewQueue(authProvider.currentUser!.id);
    }

    // If no review queue, use all characters shuffled
    if (provider.reviewQueue.isNotEmpty) {
      _practiceQueue = List.from(provider.reviewQueue);
    } else {
      _practiceQueue = List.from(provider.characters);
      _practiceQueue.shuffle();
    }

    setState(() => _isLoading = false);
  }

  void _startSession() {
    if (_practiceQueue.isEmpty) return;

    setState(() {
      _sessionActive = true;
      _currentIndex = 0;
      _correctCount = 0;
      _wrongCount = 0;
      _answered = false;
      _selectedOptionIndex = null;
    });

    _generateOptions();
    _stopwatch.reset();
    _stopwatch.start();
  }

  void _generateOptions() {
    final provider = Provider.of<HangulProvider>(context, listen: false);
    final currentChar = _practiceQueue[_currentIndex];

    // Get 3 wrong options (different from current)
    final wrongOptions = provider.characters
        .where((c) => c.id != currentChar.id)
        .toList()
      ..shuffle();

    _options = [currentChar, ...wrongOptions.take(3)];
    _options.shuffle();
  }

  void _checkAnswer(int optionIndex) {
    if (_answered) return;

    _stopwatch.stop();
    final currentChar = _practiceQueue[_currentIndex];
    final selectedChar = _options[optionIndex];
    final isCorrect = selectedChar.id == currentChar.id;

    setState(() {
      _answered = true;
      _selectedOptionIndex = optionIndex;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
    });

    // Record practice result
    _recordPractice(isCorrect);
  }

  Future<void> _recordPractice(bool isCorrect) async {
    final provider = Provider.of<HangulProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await provider.recordPractice(
        userId: authProvider.currentUser!.id,
        characterId: _practiceQueue[_currentIndex].id,
        isCorrect: isCorrect,
        responseTime: _stopwatch.elapsedMilliseconds,
      );
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _practiceQueue.length - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _selectedOptionIndex = null;
      });
      _generateOptions();
      _stopwatch.reset();
      _stopwatch.start();
    } else {
      _showSessionComplete();
    }
  }

  void _showSessionComplete() {
    final l10n = AppLocalizations.of(context)!;
    final total = _correctCount + _wrongCount;
    final accuracy = total > 0 ? (_correctCount / total * 100).toStringAsFixed(0) : '0';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.practiceComplete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _correctCount > _wrongCount ? Icons.celebration : Icons.sentiment_satisfied,
              size: 64,
              color: _correctCount > _wrongCount ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResultItem(l10n.correct, '$_correctCount', Colors.green),
                _buildResultItem(l10n.wrong, '$_wrongCount', Colors.red),
                _buildResultItem(l10n.accuracy, '$accuracy%', Colors.blue),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _sessionActive = false;
              });
            },
            child: Text(l10n.back),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _practiceQueue.shuffle();
              _startSession();
            },
            child: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_sessionActive) {
      return _buildStartScreen();
    }

    return _buildPracticeContent();
  }

  Widget _buildStartScreen() {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<HangulProvider>(context);
    final dueCount = provider.dueForReviewCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats card
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor.withValues(alpha: 0.2),
                  AppConstants.primaryColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.school,
                  size: 48,
                  color: AppConstants.textPrimary,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.hangulPractice,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (dueCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.charactersNeedReview(dueCount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  Text(
                    l10n.charactersAvailable(_practiceQueue.length),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Practice mode selection
          Text(
            l10n.selectPracticeMode,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          _buildModeCard(
            PracticeMode.recognition,
            l10n.characterRecognition,
            l10n.characterRecognitionDesc,
            Icons.visibility,
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildModeCard(
            PracticeMode.pronunciation,
            l10n.pronunciationPractice,
            l10n.pronunciationPracticeDesc,
            Icons.record_voice_over,
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildModeCard(
            PracticeMode.writing,
            l10n.writingPractice,
            l10n.writingPracticeDesc,
            Icons.edit,
            Colors.purple,
          ),

          const SizedBox(height: 32),

          // Start button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _practiceQueue.isNotEmpty ? _startSession : null,
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.startPractice),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
              ),
            ),
          ),

          if (_practiceQueue.isEmpty) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                l10n.learnSomeCharactersFirst,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeCard(
    PracticeMode mode,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _practiceMode == mode;

    return GestureDetector(
      onTap: () => setState(() => _practiceMode = mode),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : AppConstants.textPrimary,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color)
            else
              Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeContent() {
    final l10n = AppLocalizations.of(context)!;
    final currentChar = _practiceQueue[_currentIndex];
    final progress = (_currentIndex + 1) / _practiceQueue.length;

    return Column(
      children: [
        // Progress bar
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_currentIndex + 1}/${_practiceQueue.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      Text(' $_correctCount  ', style: const TextStyle(fontSize: 12)),
                      const Icon(Icons.close, size: 16, color: Colors.red),
                      Text(' $_wrongCount', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppConstants.primaryColor,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              children: [
                // Question card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingXLarge),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (_practiceMode == PracticeMode.recognition) ...[
                        // Show character, ask for pronunciation
                        Text(
                          currentChar.character,
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.howToReadThis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ] else if (_practiceMode == PracticeMode.pronunciation) ...[
                        // Show pronunciation, ask for character
                        Text(
                          currentChar.pronunciationZh,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentChar.romanization,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.selectCorrectCharacter,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ] else ...[
                        // Writing mode - show pronunciation
                        Text(
                          currentChar.pronunciationZh,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.writeCharacterForPronunciation,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Options
                if (_practiceMode != PracticeMode.writing)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: _practiceMode == PracticeMode.recognition
                          ? 2.5
                          : 1.5,
                    ),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      return _buildOptionButton(index);
                    },
                  )
                else
                  _buildWritingArea(),

                // Feedback and next button
                if (_answered) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.cancel,
                          color: _isCorrect ? Colors.green : Colors.red,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isCorrect ? l10n.correctExclamation : l10n.incorrectExclamation,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                        if (!_isCorrect) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(l10n.correctAnswerLabel),
                              Text(
                                currentChar.character,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(' = '),
                              Text(
                                currentChar.pronunciationZh,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentIndex < _practiceQueue.length - 1 ? l10n.nextQuestionBtn : l10n.viewResults,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(int index) {
    final option = _options[index];
    final currentChar = _practiceQueue[_currentIndex];
    final isCorrectOption = option.id == currentChar.id;
    final isSelected = _selectedOptionIndex == index;

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color textColor = AppConstants.textPrimary;

    if (_answered) {
      if (isCorrectOption) {
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green;
      } else if (isSelected && !isCorrectOption) {
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = AppConstants.primaryColor.withValues(alpha: 0.2);
      borderColor = AppConstants.primaryColor;
    }

    return GestureDetector(
      onTap: _answered ? null : () => _checkAnswer(index),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: _practiceMode == PracticeMode.recognition
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.romanization,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.pronunciationZh,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                )
              : Text(
                  option.character,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildWritingArea() {
    // Simplified writing area - in a real app, this would have handwriting recognition
    final l10n = AppLocalizations.of(context)!;
    final currentChar = _practiceQueue[_currentIndex];

    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              l10n.writeHere,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppConstants.textHint),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _answered = true;
                  _isCorrect = false;
                  _wrongCount++;
                });
                _recordPractice(false);
              },
              child: Text(l10n.dontKnow),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // Show answer
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentChar.character,
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.didYouWriteCorrectly),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          setState(() {
                            _answered = true;
                            _isCorrect = false;
                            _wrongCount++;
                          });
                          _recordPractice(false);
                        },
                        child: Text(l10n.wrongAnswer),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          setState(() {
                            _answered = true;
                            _isCorrect = true;
                            _correctCount++;
                          });
                          _recordPractice(true);
                        },
                        child: Text(l10n.correctAnswer),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
              ),
              child: Text(l10n.checkAnswer),
            ),
          ],
        ),
      ],
    );
  }
}

/// Practice mode types
enum PracticeMode {
  recognition, // See character, choose pronunciation
  pronunciation, // See pronunciation, choose character
  writing, // See pronunciation, write character
}
