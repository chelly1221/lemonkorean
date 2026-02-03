import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/media_loader.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import 'quiz_shared.dart';

/// Listening Question Widget
/// Audio-based comprehension question
class ListeningQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const ListeningQuestion({
    required this.question,
    required this.onAnswer,
    this.userAnswer,
    this.isCorrect,
    super.key,
  });

  @override
  State<ListeningQuestion> createState() => _ListeningQuestionState();
}

class _ListeningQuestionState extends State<ListeningQuestion> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    final audioPath = widget.question['audio'] as String?;

    if (audioPath != null) {
      try {
        if (_isPlaying) {
          await _audioPlayer.stop();
          return;
        }

        final localPath = await MediaLoader.getAudioPath(audioPath);

        if (localPath.startsWith('http')) {
          await _audioPlayer.play(UrlSource(localPath));
        } else {
          await _audioPlayer.play(DeviceFileSource(localPath));
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.audioPlayFailed(e.toString())),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswered = widget.userAnswer != null;
    final options = widget.question['options'] as List;
    final correct = widget.question['correct'] as String;

    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        QuestionTypeBadge(
          label: l10n.listening,
          icon: Icons.headphones,
          color: Colors.blue,
        ),

        const SizedBox(height: 20),

        Text(
          widget.question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        // Audio player
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Column(
            children: [
              Icon(
                Icons.graphic_eq,
                size: 80,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return ElevatedButton.icon(
                    onPressed: _playAudio,
                    icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                    label: Text(_isPlaying ? l10n.stopBtn : l10n.playAudioBtn),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Options
        ...options.map((option) => OptionTile(
              option: option,
              isSelected: widget.userAnswer == option,
              isCorrect: option == correct,
              hasAnswered: hasAnswered,
              onTap: () => widget.onAnswer(option),
            )),

        // Feedback
        if (hasAnswered)
          QuestionFeedback(
            isCorrect: widget.isCorrect ?? false,
            correctAnswer: correct,
          ),
      ],
    );
  }
}
