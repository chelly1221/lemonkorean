/// Result containing both mean-pooled embedding and frame-level data.
class EmbeddingResult {
  final List<double> embedding;
  final List<List<double>> frames;
  const EmbeddingResult({required this.embedding, required this.frames});
}

/// Web stub for GopService — embedding extraction is not supported on web.
class GopService {
  static final GopService instance = GopService._();
  GopService._();

  bool get isInitialized => false;
  bool get isModelReady => false;

  static const int embeddingDim = 1024;

  Future<void> initialize() async {}

  Future<List<double>?> extractEmbedding(String audioPath) async => null;

  Future<EmbeddingResult?> extractEmbeddingWithFrames(String audioPath) async => null;

  void dispose() {}
}
