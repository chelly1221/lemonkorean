import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/media_loader.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../widgets/convertible_text.dart';

/// Vocabulary Stage with Flip Card Animation
/// Shows vocabulary cards with images, audio, and Chinese translations
class VocabularyStage extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const VocabularyStage({
    required this.lesson, required this.onNext, required this.onPrevious, super.key,
  });

  @override
  State<VocabularyStage> createState() => _VocabularyStageState();
}

class _VocabularyStageState extends State<VocabularyStage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  int _currentCardIndex = 0;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFront = true;

  // Mock vocabulary data
  final List<Map<String, dynamic>> _mockWords = [
    {
      'korean': '안녕하세요',
      'pronunciation': 'an-nyeong-ha-se-yo',
      'chinese': '您好',
      'pinyin': 'nín hǎo',
      'hanja': '安寧',
      'similarity': 85,
      'image': 'vocabulary/hello.jpg',
      'audio': 'vocabulary/hello.mp3',
    },
    {
      'korean': '감사합니다',
      'pronunciation': 'gam-sa-ham-ni-da',
      'chinese': '谢谢',
      'pinyin': 'xiè xie',
      'hanja': '感謝',
      'similarity': 90,
      'image': 'vocabulary/thank_you.jpg',
      'audio': 'vocabulary/thank_you.mp3',
    },
    {
      'korean': '죄송합니다',
      'pronunciation': 'joe-song-ham-ni-da',
      'chinese': '对不起',
      'pinyin': 'duì bu qǐ',
      'hanja': '罪悚',
      'similarity': 75,
      'image': 'vocabulary/sorry.jpg',
      'audio': 'vocabulary/sorry.mp3',
    },
    {
      'korean': '네',
      'pronunciation': 'ne',
      'chinese': '是',
      'pinyin': 'shì',
      'hanja': null,
      'similarity': 60,
      'image': 'vocabulary/yes.jpg',
      'audio': 'vocabulary/yes.mp3',
    },
    {
      'korean': '아니요',
      'pronunciation': 'a-ni-yo',
      'chinese': '不是',
      'pinyin': 'bù shì',
      'hanja': null,
      'similarity': 50,
      'image': 'vocabulary/no.jpg',
      'audio': 'vocabulary/no.mp3',
    },
    {
      'korean': '물',
      'pronunciation': 'mul',
      'chinese': '水',
      'pinyin': 'shuǐ',
      'hanja': '水',
      'similarity': 100,
      'image': 'vocabulary/water.jpg',
      'audio': 'vocabulary/water.mp3',
    },
    {
      'korean': '밥',
      'pronunciation': 'bap',
      'chinese': '饭',
      'pinyin': 'fàn',
      'hanja': null,
      'similarity': 40,
      'image': 'vocabulary/rice.jpg',
      'audio': 'vocabulary/rice.mp3',
    },
    {
      'korean': '학교',
      'pronunciation': 'hak-gyo',
      'chinese': '学校',
      'pinyin': 'xué xiào',
      'hanja': '學校',
      'similarity': 100,
      'image': 'vocabulary/school.jpg',
      'audio': 'vocabulary/school.mp3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFront = !_isFront;
        });
        _flipController.reset();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (!_flipController.isAnimating) {
      _flipController.forward();
    }
  }

  void _nextCard() {
    if (_currentCardIndex < _mockWords.length - 1) {
      setState(() {
        _currentCardIndex++;
        _isFront = true;
      });
    } else {
      widget.onNext();
    }
  }

  void _previousCard() {
    if (_currentCardIndex > 0) {
      setState(() {
        _currentCardIndex--;
        _isFront = true;
      });
    }
  }

  Future<void> _playAudio() async {
    final word = _mockWords[_currentCardIndex];
    final audioPath = word['audio'] as String?;

    if (audioPath != null) {
      try {
        // Try to get local audio path first
        final localPath = await MediaLoader.getAudioPath(audioPath);

        // Stop any currently playing audio
        await _audioPlayer.stop();

        // Check if it's a local file or remote URL
        if (localPath.startsWith('http')) {
          await _audioPlayer.play(UrlSource(localPath));
        } else {
          await _audioPlayer.play(DeviceFileSource(localPath));
        }

        // Show feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: ConvertibleText('播放音频...'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ConvertibleText('音频播放失败: $e'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = _mockWords[_currentCardIndex];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const Text(
            '词汇学习',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Progress Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentCardIndex + 1} / ${_mockWords.length}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Flip hint
              if (_isFront)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 16,
                        color: AppConstants.primaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '点击翻转',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: LinearProgressIndicator(
              value: (_currentCardIndex + 1) / _mockWords.length,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Flip Card
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * math.pi;
                  final isUnder = angle > math.pi / 2;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: isUnder
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child: _buildBackCard(word),
                          )
                        : _buildFrontCard(word),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Navigation Buttons
          Row(
            children: [
              // Previous Button
              if (_currentCardIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousCard,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: const ConvertibleText('上一个'),
                  ),
                ),

              if (_currentCardIndex > 0) const SizedBox(width: 16),

              // Next Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _nextCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                  child: Text(
                    _currentCardIndex < _mockWords.length - 1
                        ? '下一个'
                        : '继续',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build front side of the card (Korean)
  Widget _buildFrontCard(Map<String, dynamic> word) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppConstants.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: FutureBuilder<String>(
              future: MediaLoader.getImagePath(word['image']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final imagePath = snapshot.data!;
                  final isLocal = !imagePath.startsWith('http');

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusMedium,
                    ),
                    child: isLocal
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          )
                        : Image.network(
                            imagePath,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          ),
                  );
                }
                return _buildPlaceholderImage();
              },
            ),
          ),

          const SizedBox(height: 30),

          // Korean Word
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  word['korean'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Pronunciation
                Text(
                  word['pronunciation'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 20),

                // Audio Button
                ElevatedButton.icon(
                  onPressed: _playAudio,
                  icon: const Icon(Icons.volume_up),
                  label: const Text('发音'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build back side of the card (Chinese)
  Widget _buildBackCard(Map<String, dynamic> word) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor.withOpacity(0.1),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Chinese Translation
          Text(
            word['chinese'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          // Pinyin
          Text(
            word['pinyin'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: AppConstants.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 40),

          // Hanja (if available)
          if (word['hanja'] != null) ...[
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  AppConstants.radiusMedium,
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  const Text(
                    '汉字词',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    word['hanja'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Similarity Score
          _buildSimilarityBar(word['similarity'] as int),

          const Spacer(),

          // Back indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppConstants.textHint.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 16,
                  color: AppConstants.textHint,
                ),
                SizedBox(width: 4),
                Text(
                  '点击返回',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build similarity progress bar
  Widget _buildSimilarityBar(int similarity) {
    Color barColor;
    if (similarity >= 80) {
      barColor = AppConstants.successColor;
    } else if (similarity >= 60) {
      barColor = AppConstants.primaryColor;
    } else {
      barColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '与中文相似度',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: AppConstants.textSecondary,
                ),
              ),
              Text(
                '$similarity%',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: LinearProgressIndicator(
              value: similarity / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 8),
          // Similarity hint
          Text(
            _getSimilarityHint(similarity),
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: barColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getSimilarityHint(int similarity) {
    if (similarity >= 90) {
      return '汉字词，发音相似';
    } else if (similarity >= 70) {
      return '词源相同，便于记忆';
    } else if (similarity >= 50) {
      return '有一定联系';
    } else {
      return '固有词，需要记忆';
    }
  }

  /// Build placeholder image when image is not available
  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 80,
          color: AppConstants.textHint,
        ),
      ),
    );
  }
}
