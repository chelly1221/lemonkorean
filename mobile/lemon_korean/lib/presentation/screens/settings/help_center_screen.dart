import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/chinese_converter.dart';
import '../../providers/settings_provider.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _title = '帮助中心';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTexts();
  }

  Future<void> _updateTexts() async {
    final settings = context.read<SettingsProvider>();
    if (settings.chineseVariant == ChineseVariant.traditional) {
      final converted = await ChineseConverter.toTraditional('帮助中心');
      if (mounted) {
        setState(() {
          _title = converted;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _title = '帮助中心';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title / 도움말 센터'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 오프라인 학습 섹션
          _buildSectionHeader(context, '离线学习 / 오프라인 학습'),
          _buildFAQItem(
            context,
            question: '如何下载课程？ / 레슨을 다운로드하려면?',
            answer:
                '在课程列表中，点击右侧的下载图标即可下载课程。下载后可以离线学习。\n\n레슨 목록에서 오른쪽의 다운로드 아이콘을 클릭하면 레슨을 다운로드할 수 있습니다. 다운로드 후 오프라인으로 학습할 수 있습니다.',
          ),
          _buildFAQItem(
            context,
            question: '如何使用已下载的课程？ / 다운로드한 레슨 사용하기',
            answer:
                '即使没有网络连接，您也可以正常学习已下载的课程。进度会在本地保存，联网后自动同步。\n\n네트워크 연결이 없어도 다운로드한 레슨을 정상적으로 학습할 수 있습니다. 진도는 로컬에 저장되고, 온라인 상태에서 자동으로 동기화됩니다.',
          ),

          const SizedBox(height: 24),

          // 저장공간 관리 섹션
          _buildSectionHeader(context, '存储管理 / 저장공간 관리'),
          _buildFAQItem(
            context,
            question: '如何查看存储空间？ / 저장공간 확인하기',
            answer:
                '进入"设置 → 存储管理"可以查看已使用和可用的存储空间。\n\n"설정 → 저장공간 관리"에서 사용 중인 공간과 사용 가능한 공간을 확인할 수 있습니다.',
          ),
          _buildFAQItem(
            context,
            question: '如何删除已下载的课程？ / 다운로드한 레슨 삭제하기',
            answer:
                '在"存储管理"页面，点击课程旁边的删除按钮即可删除。\n\n"저장공간 관리" 페이지에서 레슨 옆의 삭제 버튼을 클릭하면 삭제할 수 있습니다.',
          ),

          const SizedBox(height: 24),

          // 알림 설정 섹션
          _buildSectionHeader(context, '通知设置 / 알림 설정'),
          _buildFAQItem(
            context,
            question: '如何开启学习提醒？ / 학습 알림 활성화하기',
            answer:
                '进入"设置 → 通知设置"，打开"启用通知"开关。首次使用需要授予通知权限。\n\n"설정 → 알림 설정"으로 이동하여 "알림 활성화" 스위치를 켭니다. 처음 사용 시 알림 권한을 허용해야 합니다.',
          ),
          _buildFAQItem(
            context,
            question: '什么是复习提醒？ / 복습 알림이란?',
            answer:
                '基于间隔重复算法（SRS），应用会在最佳时间提醒您复习已学课程。复习间隔：1天 → 3天 → 7天 → 14天 → 30天。\n\nSRS 알고리즘을 기반으로 앱이 최적의 시간에 학습한 레슨을 복습하도록 알려줍니다. 복습 간격: 1일 → 3일 → 7일 → 14일 → 30일.',
          ),

          const SizedBox(height: 24),

          // 언어 설정 섹션
          _buildSectionHeader(context, '语言设置 / 언어 설정'),
          _buildFAQItem(
            context,
            question: '如何切换简繁体中文？ / 간체/번체 중국어 변경하기',
            answer:
                '进入"设置 → 语言设置"，选择"简体中文"或"繁體中文"。更改后立即生效。\n\n"설정 → 언어 설정"에서 "简体中文" 또는 "繁體中文"을 선택하세요. 변경 사항이 즉시 적용됩니다.',
          ),

          const SizedBox(height: 24),

          // 일반 사항 섹션
          _buildSectionHeader(context, '常见问题 / 일반 FAQ'),
          _buildFAQItem(
            context,
            question: '如何开始学习？ / 학습 시작하기',
            answer:
                '在主页面选择适合您水平的课程，从第1课开始。每节课包含7个学习阶段。\n\n홈 화면에서 수준에 맞는 레슨을 선택하고 1과부터 시작하세요. 각 레슨은 7개의 학습 단계로 구성됩니다.',
          ),
          _buildFAQItem(
            context,
            question: '进度没有保存怎么办？ / 진도가 저장되지 않을 때',
            answer:
                '进度会自动保存到本地。如果联网，会自动同步到服务器。请检查网络连接。\n\n진도는 자동으로 로컬에 저장됩니다. 온라인 상태에서는 서버에 자동으로 동기화됩니다. 네트워크 연결을 확인하세요.',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String text) {
    return FutureBuilder<String>(
      future: _convertText(text),
      initialData: text,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            snapshot.data ?? text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: FutureBuilder<String>(
          future: _convertText(question),
          initialData: question,
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? question,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
        children: [
          FutureBuilder<String>(
            future: _convertText(answer),
            initialData: answer,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.data ?? answer,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.grey[700],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> _convertText(String text) async {
    final settings = context.read<SettingsProvider>();
    if (settings.chineseVariant == ChineseVariant.traditional) {
      return await ChineseConverter.toTraditional(text);
    }
    return text;
  }
}
