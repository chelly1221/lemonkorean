import 'package:flutter/material.dart';

import '../../../../core/services/speech_model_manager.dart';

/// Widget showing speech recognition model status in settings.
/// Models are bundled with the app — no download needed.
class SpeechModelManagerWidget extends StatefulWidget {
  const SpeechModelManagerWidget({super.key});

  @override
  State<SpeechModelManagerWidget> createState() =>
      _SpeechModelManagerWidgetState();
}

class _SpeechModelManagerWidgetState extends State<SpeechModelManagerWidget> {
  int _modelsSizeBytes = 0;
  bool _modelsReady = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final ready = await SpeechModelManager.instance.areModelsReady();
    final size = await SpeechModelManager.instance.getModelsSize();
    if (mounted) {
      setState(() {
        _modelsReady = ready;
        _modelsSizeBytes = size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.record_voice_over, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '발음 인식 AI 모델',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: const Text(
                  '내장',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '오프라인 발음 평가를 위한 AI 모델 (앱 내장)',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                _modelsReady ? Icons.check_circle : Icons.hourglass_top,
                size: 14,
                color: _modelsReady ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                _modelsReady
                    ? '사용 중 (${SpeechModelManager.formatBytes(_modelsSizeBytes)})'
                    : '초기화 대기 중',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
