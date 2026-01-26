import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../widgets/bilingual_text.dart';

/// Stage 7: Summary
/// Lesson completion summary with achievements and next steps
class Stage7Summary extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onComplete;
  final VoidCallback onPrevious;

  const Stage7Summary({
    required this.lesson, required this.onComplete, required this.onPrevious, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            const SizedBox(height: 40),

          // Completion Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.celebration,
              size: 64,
              color: Colors.black87,
            ),
          )
              .animate()
              .scale(
                delay: 200.ms,
                duration: 600.ms,
                curve: Curves.elasticOut,
              )
              .then()
              .shake(duration: 500.ms),

          const SizedBox(height: 40),

          // Completion Title
          const BilingualText(
            chinese: '课程完成！',
            korean: '수업 완료!',
            chineseStyle: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

          const SizedBox(height: 16),

          // Lesson Title
          Text(
            lesson.titleZh,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: AppConstants.textSecondary,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

          const SizedBox(height: 40),

          // Achievement Cards
          _buildAchievementCard(
            icon: Icons.check_circle,
            titleChinese: '学习完成',
            titleKorean: '학습 완료',
            subtitleChinese: '7个阶段全部通过',
            subtitleKorean: '7단계 모두 통과',
            color: AppConstants.successColor,
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideX(begin: -0.2, end: 0, delay: 800.ms),

          const SizedBox(height: 12),

          _buildAchievementCard(
            icon: Icons.military_tech,
            titleChinese: '经验值 +${lesson.level * 10}',
            titleKorean: '경험치 +${lesson.level * 10}',
            subtitleChinese: '继续保持学习热情',
            subtitleKorean: '학습 열정을 유지하세요',
            color: AppConstants.primaryColor,
          )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)
              .slideX(begin: -0.2, end: 0, delay: 1000.ms),

          const SizedBox(height: 12),

          _buildAchievementCard(
            icon: Icons.local_fire_department,
            titleChinese: '学习连续天数 +1',
            titleKorean: '연속 학습일 +1',
            subtitleChinese: '已连续学习 7 天',
            subtitleKorean: '7일 연속 학습 중',
            color: Colors.orange,
          )
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms)
              .slideX(begin: -0.2, end: 0, delay: 1200.ms),

          const SizedBox(height: 40),

          // Review Stats
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Column(
              children: [
                const BilingualText(
                  chinese: '本课学习内容',
                  korean: '이번 수업 내용',
                  chineseStyle: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.translate,
                      labelChinese: '单词',
                      labelKorean: '단어',
                      value: '${lesson.vocabularyCount}',
                    ),
                    _buildStatItem(
                      icon: Icons.menu_book,
                      labelChinese: '语法点',
                      labelKorean: '문법',
                      value: '3',
                    ),
                    _buildStatItem(
                      icon: Icons.chat_bubble_outline,
                      labelChinese: '对话',
                      labelKorean: '대화',
                      value: '2',
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 1400.ms, duration: 600.ms),

          const SizedBox(height: 30),

          // Next Lesson Preview
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${lesson.level + 1}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InlineBilingualText(
                        chinese: '下一课',
                        korean: '다음 수업',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      InlineBilingualText(
                        chinese: '继续学习更多内容',
                        korean: '더 많은 내용 학습',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstants.textSecondary,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 1600.ms, duration: 600.ms),

          const SizedBox(height: 30),

          // Complete Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingLarge,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                elevation: 0,
              ),
              child: const InlineBilingualText(
                chinese: '完成',
                korean: '완료',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 1800.ms, duration: 600.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 1800.ms,
                duration: 600.ms,
              ),

          const SizedBox(height: 16),
        ],
      ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String titleChinese,
    required String titleKorean,
    required String subtitleChinese,
    required String subtitleKorean,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InlineBilingualText(
                  chinese: titleChinese,
                  korean: titleKorean,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                InlineBilingualText(
                  chinese: subtitleChinese,
                  korean: subtitleKorean,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String labelChinese,
    required String labelKorean,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        InlineBilingualText(
          chinese: labelChinese,
          korean: labelKorean,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }
}
