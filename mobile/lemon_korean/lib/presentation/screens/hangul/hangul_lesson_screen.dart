import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/hangul_character_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/hangul_provider.dart';
import 'hangul_character_detail.dart';
import 'widgets/pronunciation_player.dart';

/// Hangul Lesson Screen
/// Progressive learning of Korean alphabet characters
class HangulLessonScreen extends StatefulWidget {
  const HangulLessonScreen({super.key});

  @override
  State<HangulLessonScreen> createState() => _HangulLessonScreenState();
}

class _HangulLessonScreenState extends State<HangulLessonScreen> {
  int _currentLessonIndex = 0;
  int _currentCharacterIndex = 0;

  late List<_LessonSection> _lessons;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    final provider = Provider.of<HangulProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    _lessons = [
      _LessonSection(
        title: l10n.lesson1Title,
        titleKo: l10n.lesson1TitleKo,
        description: l10n.lesson1Desc,
        characters: provider.basicConsonants.take(7).toList(),
        color: Colors.blue,
      ),
      _LessonSection(
        title: l10n.lesson2Title,
        titleKo: l10n.lesson2TitleKo,
        description: l10n.lesson2Desc,
        characters: provider.basicConsonants.skip(7).toList(),
        color: Colors.blue.shade700,
      ),
      _LessonSection(
        title: l10n.lesson3Title,
        titleKo: l10n.lesson3TitleKo,
        description: l10n.lesson3Desc,
        characters: provider.basicVowels.take(5).toList(),
        color: Colors.green,
      ),
      _LessonSection(
        title: l10n.lesson4Title,
        titleKo: l10n.lesson4TitleKo,
        description: l10n.lesson4Desc,
        characters: provider.basicVowels.skip(5).toList(),
        color: Colors.green.shade700,
      ),
      _LessonSection(
        title: l10n.lesson5Title,
        titleKo: l10n.lesson5TitleKo,
        description: l10n.lesson5Desc,
        characters: provider.doubleConsonants,
        color: Colors.indigo,
      ),
      _LessonSection(
        title: l10n.lesson6Title,
        titleKo: l10n.lesson6TitleKo,
        description: l10n.lesson6Desc,
        characters: provider.compoundVowels.take(6).toList(),
        color: Colors.teal,
      ),
      _LessonSection(
        title: l10n.lesson7Title,
        titleKo: l10n.lesson7TitleKo,
        description: l10n.lesson7Desc,
        characters: provider.compoundVowels.skip(6).toList(),
        color: Colors.teal.shade700,
      ),
    ];

    // Remove empty lessons
    _lessons = _lessons.where((l) => l.characters.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_lessons.isEmpty) {
      return Center(
        child: Text(l10n.loadAlphabetFirst),
      );
    }

    return Consumer<HangulProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Lesson selector
            _buildLessonSelector(),

            // Lesson content
            Expanded(
              child: _buildLessonContent(provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLessonSelector() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _lessons.length,
        itemBuilder: (context, index) {
          final lesson = _lessons[index];
          final isSelected = index == _currentLessonIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _currentLessonIndex = index;
                _currentCharacterIndex = 0;
              });
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? lesson.color.withValues(alpha: 0.1) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? lesson.color : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.book : Icons.book_outlined,
                    color: isSelected ? lesson.color : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.lessonNumber(index + 1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? lesson.color : Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    l10n.charactersCount(lesson.characters.length),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonContent(HangulProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final lesson = _lessons[_currentLessonIndex];

    if (lesson.characters.isEmpty) {
      return Center(
        child: Text(
          l10n.noContentForLesson,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    final character = lesson.characters[_currentCharacterIndex];
    final totalInLesson = lesson.characters.length;
    final progressPercent = (_currentCharacterIndex + 1) / totalInLesson;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson header
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: lesson.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: lesson.color,
                  ),
                ),
                Text(
                  lesson.titleKo,
                  style: TextStyle(
                    fontSize: 14,
                    color: lesson.color.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress indicator
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(lesson.color),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_currentCharacterIndex + 1}/$totalInLesson',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Character display
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HangulCharacterDetailScreen(character: character),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  border: Border.all(color: lesson.color.withValues(alpha: 0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: lesson.color.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      character.character,
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      character.romanization,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Pronunciation section
          PronunciationPlayer(character: character),

          const SizedBox(height: 16),

          // Example words
          if (character.hasExamples) ...[
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.exampleWords,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...character.exampleWords!.take(2).map((word) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              word.korean,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              word.chinese,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Navigation buttons
          Row(
            children: [
              // Previous button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _currentCharacterIndex > 0
                      ? () {
                          setState(() {
                            _currentCharacterIndex--;
                                      });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(l10n.previous),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Next button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentCharacterIndex < totalInLesson - 1
                      ? () {
                          setState(() {
                            _currentCharacterIndex++;
                                      });
                        }
                      : () => _showLessonComplete(),
                  icon: Icon(
                    _currentCharacterIndex < totalInLesson - 1
                        ? Icons.arrow_forward
                        : Icons.check,
                  ),
                  label: Text(
                    _currentCharacterIndex < totalInLesson - 1 ? l10n.next : l10n.finish,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lesson.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Character overview grid
          Text(
            l10n.thisLessonCharacters,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: lesson.characters.length,
            itemBuilder: (context, index) {
              final char = lesson.characters[index];
              final isCurrentChar = index == _currentCharacterIndex;
              final charProgress = provider.getProgressForCharacter(char.id);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentCharacterIndex = index;
                      });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrentChar
                        ? lesson.color.withValues(alpha: 0.2)
                        : _getProgressColor(charProgress),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrentChar ? lesson.color : Colors.grey.shade300,
                      width: isCurrentChar ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      char.character,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isCurrentChar ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Color _getProgressColor(dynamic progress) {
    if (progress == null) return Colors.white;
    final level = progress.masteryLevel ?? 0;
    if (level >= 3) return Colors.green.shade50;
    if (level >= 1) return Colors.blue.shade50;
    return Colors.white;
  }

  void _showLessonComplete() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.lessonComplete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              size: 64,
              color: _lessons[_currentLessonIndex].color,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.congratsLessonComplete(_lessons[_currentLessonIndex].title),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.continuePractice),
          ),
          if (_currentLessonIndex < _lessons.length - 1)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentLessonIndex++;
                  _currentCharacterIndex = 0;
                });
              },
              child: Text(l10n.nextLesson),
            ),
        ],
      ),
    );
  }
}

/// Lesson section data class
class _LessonSection {
  final String title;
  final String titleKo;
  final String description;
  final List<HangulCharacterModel> characters;
  final Color color;

  _LessonSection({
    required this.title,
    required this.titleKo,
    required this.description,
    required this.characters,
    required this.color,
  });
}
