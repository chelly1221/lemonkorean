import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/pronunciation_player.dart';

/// Batchim (final consonant) information
class BatchimInfo {
  final String batchim;
  final String name;
  final String pronunciation;
  final String explanation;
  final List<String> examples;
  final String soundGroup; // ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ

  const BatchimInfo({
    required this.batchim,
    required this.name,
    required this.pronunciation,
    required this.explanation,
    required this.examples,
    required this.soundGroup,
  });
}

/// All batchim information
class BatchimData {
  static const List<BatchimInfo> batchims = [
    // ㄱ group (ㄱ, ㅋ, ㄲ, ㄳ, ㄺ)
    BatchimInfo(
      batchim: 'ㄱ',
      name: '기역',
      pronunciation: '[k̚]',
      explanation: '혀 뒤쪽을 연구개에 붙여 막음',
      examples: ['국', '악', '학'],
      soundGroup: 'ㄱ',
    ),
    BatchimInfo(
      batchim: 'ㅋ',
      name: '키읔',
      pronunciation: '[k̚]',
      explanation: 'ㄱ과 같은 소리로 발음',
      examples: ['부엌'],
      soundGroup: 'ㄱ',
    ),
    BatchimInfo(
      batchim: 'ㄲ',
      name: '쌍기역',
      pronunciation: '[k̚]',
      explanation: 'ㄱ과 같은 소리로 발음',
      examples: ['밖', '껍'],
      soundGroup: 'ㄱ',
    ),

    // ㄴ group
    BatchimInfo(
      batchim: 'ㄴ',
      name: '니은',
      pronunciation: '[n]',
      explanation: '혀끝을 잇몸에 붙여 비음화',
      examples: ['산', '문', '안'],
      soundGroup: 'ㄴ',
    ),

    // ㄷ group (ㄷ, ㅌ, ㅅ, ㅆ, ㅈ, ㅊ, ㅎ)
    BatchimInfo(
      batchim: 'ㄷ',
      name: '디귿',
      pronunciation: '[t̚]',
      explanation: '혀끝을 잇몸에 붙여 막음',
      examples: ['굳', '받'],
      soundGroup: 'ㄷ',
    ),
    BatchimInfo(
      batchim: 'ㅌ',
      name: '티읕',
      pronunciation: '[t̚]',
      explanation: 'ㄷ과 같은 소리로 발음',
      examples: ['밭', '같'],
      soundGroup: 'ㄷ',
    ),
    BatchimInfo(
      batchim: 'ㅅ',
      name: '시옷',
      pronunciation: '[t̚]',
      explanation: 'ㄷ과 같은 소리로 발음',
      examples: ['옷', '있'],
      soundGroup: 'ㄷ',
    ),
    BatchimInfo(
      batchim: 'ㅆ',
      name: '쌍시옷',
      pronunciation: '[t̚]',
      explanation: 'ㄷ과 같은 소리로 발음',
      examples: ['있', '했'],
      soundGroup: 'ㄷ',
    ),
    BatchimInfo(
      batchim: 'ㅈ',
      name: '지읒',
      pronunciation: '[t̚]',
      explanation: 'ㄷ과 같은 소리로 발음',
      examples: ['낮'],
      soundGroup: 'ㄷ',
    ),
    BatchimInfo(
      batchim: 'ㅊ',
      name: '치읓',
      pronunciation: '[t̚]',
      explanation: 'ㄷ과 같은 소리로 발음',
      examples: ['꽃', '빛'],
      soundGroup: 'ㄷ',
    ),
    BatchimInfo(
      batchim: 'ㅎ',
      name: '히읗',
      pronunciation: '[t̚]',
      explanation: 'ㄷ과 같은 소리로 발음 (또는 탈락)',
      examples: ['낳', '놓'],
      soundGroup: 'ㄷ',
    ),

    // ㄹ group
    BatchimInfo(
      batchim: 'ㄹ',
      name: '리을',
      pronunciation: '[l]',
      explanation: '혀끝을 잇몸에 가볍게 붙임',
      examples: ['발', '물', '길'],
      soundGroup: 'ㄹ',
    ),

    // ㅁ group
    BatchimInfo(
      batchim: 'ㅁ',
      name: '미음',
      pronunciation: '[m]',
      explanation: '입술을 다물어 비음화',
      examples: ['감', '봄', '밤'],
      soundGroup: 'ㅁ',
    ),

    // ㅂ group (ㅂ, ㅍ)
    BatchimInfo(
      batchim: 'ㅂ',
      name: '비읍',
      pronunciation: '[p̚]',
      explanation: '입술을 다물어 막음',
      examples: ['밥', '앞', '집'],
      soundGroup: 'ㅂ',
    ),
    BatchimInfo(
      batchim: 'ㅍ',
      name: '피읖',
      pronunciation: '[p̚]',
      explanation: 'ㅂ과 같은 소리로 발음',
      examples: ['잎'],
      soundGroup: 'ㅂ',
    ),

    // ㅇ group
    BatchimInfo(
      batchim: 'ㅇ',
      name: '이응',
      pronunciation: '[ŋ]',
      explanation: '혀 뒤쪽을 연구개에 가볍게 붙여 비음화',
      examples: ['강', '공', '방'],
      soundGroup: 'ㅇ',
    ),
  ];

  static List<BatchimInfo> getBatchimsByGroup(String group) {
    return batchims.where((b) => b.soundGroup == group).toList();
  }

  static const List<String> soundGroups = ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅇ'];

  static Map<String, String> get soundGroupNames => {
        'ㄱ': 'ㄱ/ㅋ/ㄲ → [k̚]',
        'ㄴ': 'ㄴ → [n]',
        'ㄷ': 'ㄷ/ㅌ/ㅅ/ㅆ/ㅈ/ㅊ/ㅎ → [t̚]',
        'ㄹ': 'ㄹ → [l]',
        'ㅁ': 'ㅁ → [m]',
        'ㅂ': 'ㅂ/ㅍ → [p̚]',
        'ㅇ': 'ㅇ → [ŋ]',
      };
}

/// Batchim (final consonant) practice screen
class HangulBatchimScreen extends StatefulWidget {
  const HangulBatchimScreen({super.key});

  @override
  State<HangulBatchimScreen> createState() => _HangulBatchimScreenState();
}

class _HangulBatchimScreenState extends State<HangulBatchimScreen> {
  String? _selectedGroup;
  BatchimInfo? _selectedBatchim;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.batchimPractice),
      ),
      body: _selectedGroup == null
          ? _buildGroupSelection()
          : _selectedBatchim == null
              ? _buildBatchimList()
              : _buildBatchimDetail(),
    );
  }

  Widget _buildGroupSelection() {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      l10n.batchimExplanation,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '한국어 받침은 7가지 소리로 발음됩니다.\n'
                  '여러 받침이 같은 소리로 발음되는 것을 "받침 대표음"이라고 합니다.',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 7 sound groups
          Text(
            '7가지 대표음',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...BatchimData.soundGroups.map((group) => _buildGroupCard(group)),
        ],
      ),
    );
  }

  Widget _buildGroupCard(String group) {
    final groupName = BatchimData.soundGroupNames[group] ?? group;
    final batchims = BatchimData.getBatchimsByGroup(group);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selectedGroup = group),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Representative sound
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getGroupColor(group).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getGroupColor(group),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    group,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _getGroupColor(group),
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
                      groupName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: batchims
                          .map((b) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  b.batchim,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatchimList() {
    final batchims = BatchimData.getBatchimsByGroup(_selectedGroup!);

    return Column(
      children: [
        // Back button and title
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getGroupColor(_selectedGroup!).withValues(alpha: 0.1),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _selectedGroup = null),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              Text(
                BatchimData.soundGroupNames[_selectedGroup!] ?? _selectedGroup!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: batchims.length,
            itemBuilder: (context, index) {
              final batchim = batchims[index];
              return _buildBatchimCard(batchim);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBatchimCard(BatchimInfo batchim) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selectedBatchim = batchim),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Batchim character
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    batchim.batchim,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
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
                      batchim.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '발음: ${batchim.pronunciation}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Examples
              Wrap(
                spacing: 4,
                children: batchim.examples
                    .take(2)
                    .map((ex) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getGroupColor(_selectedGroup!)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ex,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatchimDetail() {
    final batchim = _selectedBatchim!;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Back button and title
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getGroupColor(_selectedGroup!).withValues(alpha: 0.1),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _selectedBatchim = null),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                Text(
                  '${batchim.batchim} (${batchim.name})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large character display
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: _getGroupColor(_selectedGroup!).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _getGroupColor(_selectedGroup!),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        batchim.batchim,
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: _getGroupColor(_selectedGroup!),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Pronunciation
                _buildInfoSection(
                  '발음',
                  batchim.pronunciation,
                  Icons.record_voice_over,
                ),

                const SizedBox(height: 16),

                // Explanation
                _buildInfoSection(
                  '발음 방법',
                  batchim.explanation,
                  Icons.lightbulb_outline,
                ),

                const SizedBox(height: 16),

                // Examples
                Text(
                  '예시 단어',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: batchim.examples
                      .map((ex) => _buildExampleChip(ex))
                      .toList(),
                ),

                const SizedBox(height: 24),

                // Related batchims in same group
                Text(
                  '같은 소리로 발음되는 받침',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: BatchimData.getBatchimsByGroup(_selectedGroup!)
                      .where((b) => b.batchim != batchim.batchim)
                      .map((b) => ActionChip(
                            label: Text(
                              '${b.batchim} (${b.name})',
                              style: const TextStyle(fontSize: 13),
                            ),
                            onPressed: () =>
                                setState(() => _selectedBatchim = b),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleChip(String example) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            example,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // Play audio
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Playing: $example'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.volume_up, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGroupColor(String group) {
    switch (group) {
      case 'ㄱ':
        return Colors.blue;
      case 'ㄴ':
        return Colors.green;
      case 'ㄷ':
        return Colors.orange;
      case 'ㄹ':
        return Colors.purple;
      case 'ㅁ':
        return Colors.teal;
      case 'ㅂ':
        return Colors.red;
      case 'ㅇ':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
