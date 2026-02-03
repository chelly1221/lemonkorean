import 'package:hive/hive.dart';

part 'hangul_character_model.g.dart';

/// Type of hangul character (consonant or vowel)
enum HangulCharacterType {
  basicConsonant,
  doubleConsonant,
  basicVowel,
  compoundVowel,
  finalConsonant,
}

/// Example word with translation
@HiveType(typeId: 11)
class HangulExampleWord {
  @HiveField(0)
  final String korean;

  @HiveField(1)
  final String chinese;

  @HiveField(2)
  final String? pinyin;

  HangulExampleWord({
    required this.korean,
    required this.chinese,
    this.pinyin,
  });

  factory HangulExampleWord.fromJson(Map<String, dynamic> json) {
    return HangulExampleWord(
      korean: json['korean'] as String,
      chinese: json['chinese'] as String,
      pinyin: json['pinyin'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'korean': korean,
      'chinese': chinese,
      'pinyin': pinyin,
    };
  }
}

/// Hangul character model for Korean alphabet learning
@HiveType(typeId: 10)
class HangulCharacterModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String character;

  @HiveField(2)
  final String characterType;

  @HiveField(3)
  final String romanization;

  @HiveField(4)
  final String pronunciationZh;

  @HiveField(5)
  final String? pronunciationTipZh;

  @HiveField(6)
  final int strokeCount;

  @HiveField(7)
  final String? strokeOrderUrl;

  @HiveField(8)
  final String? audioUrl;

  @HiveField(9)
  final int displayOrder;

  @HiveField(10)
  final List<HangulExampleWord>? exampleWords;

  @HiveField(11)
  final String? mnemonicsZh;

  @HiveField(12)
  final String status;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  HangulCharacterModel({
    required this.id,
    required this.character,
    required this.characterType,
    required this.romanization,
    required this.pronunciationZh,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
    this.pronunciationTipZh,
    this.strokeCount = 1,
    this.strokeOrderUrl,
    this.audioUrl,
    this.exampleWords,
    this.mnemonicsZh,
    this.status = 'published',
  });

  factory HangulCharacterModel.fromJson(Map<String, dynamic> json) {
    List<HangulExampleWord>? examples;
    if (json['example_words'] != null) {
      if (json['example_words'] is List) {
        examples = (json['example_words'] as List)
            .map((e) => HangulExampleWord.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return HangulCharacterModel(
      id: json['id'] as int,
      character: json['character'] as String,
      characterType: json['character_type'] as String,
      romanization: json['romanization'] as String,
      pronunciationZh: json['pronunciation_zh'] as String,
      pronunciationTipZh: json['pronunciation_tip_zh'] as String?,
      strokeCount: json['stroke_count'] as int? ?? 1,
      strokeOrderUrl: json['stroke_order_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      displayOrder: json['display_order'] as int,
      exampleWords: examples,
      mnemonicsZh: json['mnemonics_zh'] as String?,
      status: json['status'] as String? ?? 'published',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character': character,
      'character_type': characterType,
      'romanization': romanization,
      'pronunciation_zh': pronunciationZh,
      'pronunciation_tip_zh': pronunciationTipZh,
      'stroke_count': strokeCount,
      'stroke_order_url': strokeOrderUrl,
      'audio_url': audioUrl,
      'display_order': displayOrder,
      'example_words': exampleWords?.map((e) => e.toJson()).toList(),
      'mnemonics_zh': mnemonicsZh,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  HangulCharacterModel copyWith({
    int? id,
    String? character,
    String? characterType,
    String? romanization,
    String? pronunciationZh,
    String? pronunciationTipZh,
    int? strokeCount,
    String? strokeOrderUrl,
    String? audioUrl,
    int? displayOrder,
    List<HangulExampleWord>? exampleWords,
    String? mnemonicsZh,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HangulCharacterModel(
      id: id ?? this.id,
      character: character ?? this.character,
      characterType: characterType ?? this.characterType,
      romanization: romanization ?? this.romanization,
      pronunciationZh: pronunciationZh ?? this.pronunciationZh,
      pronunciationTipZh: pronunciationTipZh ?? this.pronunciationTipZh,
      strokeCount: strokeCount ?? this.strokeCount,
      strokeOrderUrl: strokeOrderUrl ?? this.strokeOrderUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      exampleWords: exampleWords ?? this.exampleWords,
      mnemonicsZh: mnemonicsZh ?? this.mnemonicsZh,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helpers
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get hasStrokeOrder => strokeOrderUrl != null && strokeOrderUrl!.isNotEmpty;
  bool get hasExamples => exampleWords != null && exampleWords!.isNotEmpty;
  bool get hasTip => pronunciationTipZh != null && pronunciationTipZh!.isNotEmpty;
  bool get hasMnemonics => mnemonicsZh != null && mnemonicsZh!.isNotEmpty;

  bool get isConsonant =>
      characterType == 'basic_consonant' || characterType == 'double_consonant';
  bool get isVowel =>
      characterType == 'basic_vowel' || characterType == 'compound_vowel';

  String get typeDisplayName {
    switch (characterType) {
      case 'basic_consonant':
        return '基本辅音';
      case 'double_consonant':
        return '双辅音';
      case 'basic_vowel':
        return '基本元音';
      case 'compound_vowel':
        return '复合元音';
      case 'final_consonant':
        return '收音';
      default:
        return characterType;
    }
  }

  String get typeDisplayNameKo {
    switch (characterType) {
      case 'basic_consonant':
        return '기본 자음';
      case 'double_consonant':
        return '쌍자음';
      case 'basic_vowel':
        return '기본 모음';
      case 'compound_vowel':
        return '복합 모음';
      case 'final_consonant':
        return '받침';
      default:
        return characterType;
    }
  }

  @override
  String toString() {
    return 'HangulCharacterModel(id: $id, character: $character, type: $characterType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HangulCharacterModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
