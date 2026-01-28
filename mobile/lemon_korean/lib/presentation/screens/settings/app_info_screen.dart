import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/bilingual_text.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于应用 / 앱 정보'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 앱 로고 및 이름
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🍋',
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lemon Korean',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '柠檬韩语',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 버전 정보
          _buildInfoCard(
            icon: Icons.info_outline,
            title: '版本信息 / 버전 정보',
            content: 'Version 1.0.0',
          ),

          const SizedBox(height: 12),

          // 개발자 정보
          _buildInfoCard(
            icon: Icons.code,
            title: '开发者 / 개발자',
            content: 'Lemon Korean Team',
          ),

          const SizedBox(height: 12),

          // 앱 설명
          _buildInfoCard(
            icon: Icons.description,
            title: '应用介绍 / 앱 소개',
            content:
                '专为中文使用者设计的韩语学习应用，支持离线学习、智能复习提醒等功能。\n\n중국어 화자를 위한 한국어 학습 앱으로, 오프라인 학습, 스마트 복습 알림 등의 기능을 제공합니다.',
          ),

          const SizedBox(height: 32),

          // 링크 섹션 헤더
          const Text(
            '更多信息 / 추가 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // 서비스 약관
          _buildLinkItem(
            icon: Icons.article,
            chinese: '服务条款',
            korean: '이용약관',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('服务条款页面开发中... / 이용약관 페이지 개발 중...')),
              );
            },
          ),

          // 개인정보처리방침
          _buildLinkItem(
            icon: Icons.privacy_tip,
            chinese: '隐私政策',
            korean: '개인정보처리방침',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('隐私政策页面开发中... / 개인정보처리방침 페이지 개발 중...')),
              );
            },
          ),

          // 오픈소스 라이센스
          _buildLinkItem(
            icon: Icons.lightbulb_outline,
            chinese: '开源许可',
            korean: '오픈소스 라이센스',
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Lemon Korean',
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🍋', style: TextStyle(fontSize: 30)),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // 저작권 표시
          Center(
            child: Text(
              '© 2024 Lemon Korean Team\nAll rights reserved',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem({
    required IconData icon,
    required String chinese,
    required String korean,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryColor),
        title: BilingualText(
          chinese: chinese,
          korean: korean,
          textAlign: TextAlign.left,
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
