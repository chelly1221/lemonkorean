import 'package:hive/hive.dart';

part 'vocabulary_model.g.dart';

@HiveType(typeId: 2)
class VocabularyModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String korean;

  @HiveField(2)
  final String? hanja;

  @HiveField(3)
  final String chinese;

  @HiveField(4)
  final String? pinyin;

  @HiveField(5)
  final String? pronunciation;

  @HiveField(6)
  final String partOfSpeech;

  @HiveField(7)
  final int level;

  @HiveField(8)
  final double? similarityScore;

  @HiveField(9)
  final String? audioUrl;

  @HiveField(10)
  final String? imageUrl;

  @HiveField(11)
  final List<String>? exampleSentences;

  @HiveField(12)
  final List<String>? tags;

  @HiveField(13)
  final DateTime createdAt;

  VocabularyModel({
    required this.id,
    required this.korean,
    required this.chinese, required this.createdAt, this.hanja,
    this.pinyin,
    this.pronunciation,
    this.partOfSpeech = 'noun',
    this.level = 1,
    this.similarityScore,
    this.audioUrl,
    this.imageUrl,
    this.exampleSentences,
    this.tags,
  });

  // From JSON
  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id'] as int,
      korean: json['korean'] as String,
      hanja: json['hanja'] as String?,
      chinese: json['chinese'] as String,
      pinyin: json['pinyin'] as String?,
      pronunciation: json['pronunciation'] as String?,
      partOfSpeech: json['part_of_speech'] as String? ?? 'noun',
      level: json['level'] as int? ?? 1,
      similarityScore: json['similarity_score'] != null
          ? (json['similarity_score'] as num).toDouble()
          : null,
      audioUrl: json['audio_url'] as String?,
      imageUrl: json['image_url'] as String?,
      exampleSentences: json['example_sentences'] != null
          ? List<String>.from(json['example_sentences'] as List)
          : null,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'korean': korean,
      'hanja': hanja,
      'chinese': chinese,
      'pinyin': pinyin,
      'pronunciation': pronunciation,
      'part_of_speech': partOfSpeech,
      'level': level,
      'similarity_score': similarityScore,
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'example_sentences': exampleSentences,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Copy with
  VocabularyModel copyWith({
    int? id,
    String? korean,
    String? hanja,
    String? chinese,
    String? pinyin,
    String? pronunciation,
    String? partOfSpeech,
    int? level,
    double? similarityScore,
    String? audioUrl,
    String? imageUrl,
    List<String>? exampleSentences,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return VocabularyModel(
      id: id ?? this.id,
      korean: korean ?? this.korean,
      hanja: hanja ?? this.hanja,
      chinese: chinese ?? this.chinese,
      pinyin: pinyin ?? this.pinyin,
      pronunciation: pronunciation ?? this.pronunciation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      level: level ?? this.level,
      similarityScore: similarityScore ?? this.similarityScore,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      exampleSentences: exampleSentences ?? this.exampleSentences,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helpers
  bool get hasHanja => hanja != null && hanja!.isNotEmpty;
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasExamples =>
      exampleSentences != null && exampleSentences!.isNotEmpty;

  String get displayWord => hasHanja ? '$korean ($hanja)' : korean;

  String get partOfSpeechDisplay {
    switch (partOfSpeech) {
      case 'noun':
        return '名词';
      case 'verb':
        return '动词';
      case 'adjective':
        return '形容词';
      case 'adverb':
        return '副词';
      case 'particle':
        return '助词';
      case 'pronoun':
        return '代词';
      default:
        return partOfSpeech;
    }
  }

  String get similarityLevel {
    if (similarityScore == null) return '';
    if (similarityScore! >= 0.8) return '高相似度';
    if (similarityScore! >= 0.5) return '中等相似度';
    return '低相似度';
  }

  @override
  String toString() {
    return 'VocabularyModel(id: $id, korean: $korean, chinese: $chinese)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VocabularyModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
