import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';

/// Language Settings Screen
/// Allow users to choose between Simplified and Traditional Chinese
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置 / 언어 설정'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '中文显示 / 중국어 표시',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '选择中文文字显示方式。更改后将立即应用到所有界面。\n중국어 문자 표시 방식을 선택하세요. 변경 후 모든 화면에 즉시 적용됩니다.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),

          // Simplified Chinese Option
          Card(
            elevation: settings.chineseVariant == ChineseVariant.simplified ? 3 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: settings.chineseVariant == ChineseVariant.simplified
                    ? AppConstants.primaryColor
                    : Colors.grey[300]!,
                width: settings.chineseVariant == ChineseVariant.simplified ? 2 : 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: const Text(
                '简体中文',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Simplified Chinese (简体字)\n예: 学习韩语',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
              trailing: settings.chineseVariant == ChineseVariant.simplified
                  ? Icon(
                      Icons.check_circle,
                      color: AppConstants.primaryColor,
                      size: 28,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey[400],
                      size: 28,
                    ),
              onTap: () async {
                await settings.setChineseVariant(ChineseVariant.simplified);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已切换到简体中文 / 간체자로 전환되었습니다'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 12),

          // Traditional Chinese Option
          Card(
            elevation: settings.chineseVariant == ChineseVariant.traditional ? 3 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: settings.chineseVariant == ChineseVariant.traditional
                    ? AppConstants.primaryColor
                    : Colors.grey[300]!,
                width: settings.chineseVariant == ChineseVariant.traditional ? 2 : 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: const Text(
                '繁體中文',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Traditional Chinese (繁體字)\n예: 學習韓語',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
              trailing: settings.chineseVariant == ChineseVariant.traditional
                  ? Icon(
                      Icons.check_circle,
                      color: AppConstants.primaryColor,
                      size: 28,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey[400],
                      size: 28,
                    ),
              onTap: () async {
                await settings.setChineseVariant(ChineseVariant.traditional);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已切換到繁體中文 / 번체자로 전환되었습니다'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '提示：课程内容将使用您选择的中文字体显示。\n팁: 레슨 콘텐츠가 선택한 중국어 글자체로 표시됩니다.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[900],
                      height: 1.5,
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
}
