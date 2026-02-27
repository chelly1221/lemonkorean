import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

/// Manages on-device AI model files for speech recognition.
/// Models are bundled as Flutter assets and copied to the documents
/// directory on first use. Fully offline — no network required.
class SpeechModelManager {
  static final SpeechModelManager instance = SpeechModelManager._();
  SpeechModelManager._();

  bool _initialized = false;

  /// Model definitions: asset path → local file info
  static const Map<String, ModelInfo> models = {
    'whisper': ModelInfo(
      name: 'Whisper Base',
      fileName: 'ggml-base.bin',
      subDir: 'whisper',
      assetPath: 'assets/models/whisper/ggml-base.bin',
    ),
    'gop': ModelInfo(
      name: 'wav2vec2 Korean (GOP)',
      fileName: 'wav2vec2_korean_q8.onnx',
      subDir: 'gop',
      assetPath: 'assets/models/gop/wav2vec2_korean_q8.onnx',
    ),
  };

  /// Ensure all bundled models are copied to the documents directory.
  /// Called once during app initialization. Idempotent — skips if
  /// the file already exists locally.
  Future<void> ensureModelsReady() async {
    if (_initialized) return;

    for (final entry in models.entries) {
      final info = entry.value;
      final localPath = await _getModelPath(info);
      final file = File(localPath);

      if (!file.existsSync()) {
        AppLogger.i('Copying bundled model: ${info.name}', tag: 'ModelManager');
        await _copyAssetToFile(info.assetPath, localPath);
      }
    }

    _initialized = true;
    AppLogger.i('All models ready', tag: 'ModelManager');
  }

  /// Check if all models are present locally.
  Future<bool> areModelsReady() async {
    for (final entry in models.entries) {
      final path = await _getModelPath(entry.value);
      if (!File(path).existsSync()) return false;
    }
    return true;
  }

  /// Get the file path for a model.
  Future<String> getModelPath(String modelKey) async {
    final info = models[modelKey];
    if (info == null) return '';
    return _getModelPath(info);
  }

  /// Get the directory containing a model's files.
  Future<String> getModelDir(String modelKey) async {
    final info = models[modelKey];
    if (info == null) return '';
    final baseDir = await _getModelsBaseDir();
    return '$baseDir/${info.subDir}';
  }

  /// Delete all local model copies (they can be re-copied from assets).
  Future<void> deleteModels() async {
    final baseDir = await _getModelsBaseDir();
    final dir = Directory(baseDir);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    _initialized = false;
    AppLogger.i('All models deleted', tag: 'ModelManager');
  }

  /// Get total size of models on disk in bytes.
  Future<int> getModelsSize() async {
    int total = 0;
    for (final entry in models.entries) {
      final path = await _getModelPath(entry.value);
      final file = File(path);
      if (file.existsSync()) {
        total += file.lengthSync();
      }
    }
    return total;
  }

  /// Format bytes to human-readable string.
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Copy a bundled asset to a local file path.
  Future<void> _copyAssetToFile(String assetPath, String targetPath) async {
    final dir = File(targetPath).parent;
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final byteData = await rootBundle.load(assetPath);
    final file = File(targetPath);
    await file.writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
      flush: true,
    );

    AppLogger.i(
      'Model copied: $assetPath → $targetPath (${file.lengthSync()} bytes)',
      tag: 'ModelManager',
    );
  }

  Future<String> _getModelsBaseDir() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/models';
  }

  Future<String> _getModelPath(ModelInfo info) async {
    final baseDir = await _getModelsBaseDir();
    return '$baseDir/${info.subDir}/${info.fileName}';
  }
}

/// Model file metadata.
class ModelInfo {
  final String name;
  final String fileName;
  final String subDir;
  final String assetPath;

  const ModelInfo({
    required this.name,
    required this.fileName,
    required this.subDir,
    required this.assetPath,
  });
}
