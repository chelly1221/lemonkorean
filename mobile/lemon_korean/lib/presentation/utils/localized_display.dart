import '../../data/models/hangul_character_model.dart';
import '../../data/models/hangul_progress_model.dart';
import '../../data/models/progress_model.dart';
import '../../data/models/vocabulary_model.dart';
import '../../l10n/generated/app_localizations.dart';

/// Extension methods for localized display strings on VocabularyModel
extension VocabularyModelL10n on VocabularyModel {
  /// Get localized part of speech display
  String getPartOfSpeechDisplay(AppLocalizations l10n) {
    switch (partOfSpeech) {
      case 'noun':
        return l10n.partOfSpeechNoun;
      case 'verb':
        return l10n.partOfSpeechVerb;
      case 'adjective':
        return l10n.partOfSpeechAdjective;
      case 'adverb':
        return l10n.partOfSpeechAdverb;
      case 'particle':
        return l10n.partOfSpeechParticle;
      case 'pronoun':
        return l10n.partOfSpeechPronoun;
      case 'conjunction':
        return l10n.partOfSpeechConjunction;
      case 'interjection':
        return l10n.partOfSpeechInterjection;
      default:
        return partOfSpeech;
    }
  }

  /// Get localized similarity level display
  String getSimilarityLevelDisplay(AppLocalizations l10n) {
    if (similarityScore == null) return '';
    if (similarityScore! >= 0.8) return l10n.similarityHigh;
    if (similarityScore! >= 0.5) return l10n.similarityMedium;
    return l10n.similarityLow;
  }
}

/// Extension methods for localized display strings on ProgressModel
extension ProgressModelL10n on ProgressModel {
  /// Get localized time spent display
  String getTimeSpentDisplay(AppLocalizations l10n) {
    final hours = timeSpent ~/ 3600;
    final minutes = (timeSpent % 3600) ~/ 60;
    final seconds = timeSpent % 60;

    if (hours > 0) {
      return l10n.timeFormatHMS(hours, minutes, seconds);
    } else if (minutes > 0) {
      return l10n.timeFormatMS(minutes, seconds);
    } else {
      return l10n.timeFormatS(seconds);
    }
  }

  /// Get localized status display
  String getStatusDisplay(AppLocalizations l10n) {
    switch (status) {
      case 'not_started':
        return l10n.statusNotStarted;
      case 'in_progress':
        return l10n.statusInProgress;
      case 'completed':
        return l10n.statusCompleted;
      case 'failed':
        return l10n.statusFailed;
      default:
        return status;
    }
  }
}

/// Extension methods for localized display strings on ReviewModel
extension ReviewModelL10n on ReviewModel {
  /// Get localized due status display
  String getDueStatusDisplay(AppLocalizations l10n) {
    if (isDue) return l10n.dueForReviewNow;
    final days = daysUntilReview;
    if (days == 0) return l10n.today;
    if (days == 1) return l10n.tomorrow;
    return l10n.daysLater(days);
  }
}

/// Extension methods for localized display strings on HangulProgressModel
extension HangulProgressModelL10n on HangulProgressModel {
  /// Get localized mastery level name
  String getMasteryLevelDisplay(AppLocalizations l10n) {
    switch (masteryLevel) {
      case 0:
        return l10n.masteryNew;
      case 1:
        return l10n.masteryLearning;
      case 2:
        return l10n.masteryFamiliar;
      case 3:
        return l10n.masteryMastered;
      case 4:
        return l10n.masteryExpert;
      case 5:
        return l10n.masteryPerfect;
      default:
        return l10n.masteryUnknown;
    }
  }
}

/// Extension methods for localized display strings on HangulCharacterModel
extension HangulCharacterModelL10n on HangulCharacterModel {
  /// Get localized type display name
  String getTypeDisplay(AppLocalizations l10n) {
    switch (characterType) {
      case 'basic_consonant':
        return l10n.typeBasicConsonant;
      case 'double_consonant':
        return l10n.typeDoubleConsonant;
      case 'basic_vowel':
        return l10n.typeBasicVowel;
      case 'compound_vowel':
        return l10n.typeCompoundVowel;
      case 'final_consonant':
        return l10n.typeFinalConsonant;
      default:
        return characterType;
    }
  }
}

/// Static helper class for localized display strings
/// Use this when you have only the raw value, not the model instance
class LocalizedDisplay {
  /// Get localized part of speech display from raw value
  static String partOfSpeech(String pos, AppLocalizations l10n) {
    switch (pos) {
      case 'noun':
        return l10n.partOfSpeechNoun;
      case 'verb':
        return l10n.partOfSpeechVerb;
      case 'adjective':
        return l10n.partOfSpeechAdjective;
      case 'adverb':
        return l10n.partOfSpeechAdverb;
      case 'particle':
        return l10n.partOfSpeechParticle;
      case 'pronoun':
        return l10n.partOfSpeechPronoun;
      case 'conjunction':
        return l10n.partOfSpeechConjunction;
      case 'interjection':
        return l10n.partOfSpeechInterjection;
      default:
        return pos;
    }
  }

  /// Get localized progress status display from raw value
  static String progressStatus(String status, AppLocalizations l10n) {
    switch (status) {
      case 'not_started':
        return l10n.statusNotStarted;
      case 'in_progress':
        return l10n.statusInProgress;
      case 'completed':
        return l10n.statusCompleted;
      case 'failed':
        return l10n.statusFailed;
      default:
        return status;
    }
  }

  /// Get localized mastery level display from raw value
  static String masteryLevel(int level, AppLocalizations l10n) {
    switch (level) {
      case 0:
        return l10n.masteryNew;
      case 1:
        return l10n.masteryLearning;
      case 2:
        return l10n.masteryFamiliar;
      case 3:
        return l10n.masteryMastered;
      case 4:
        return l10n.masteryExpert;
      case 5:
        return l10n.masteryPerfect;
      default:
        return l10n.masteryUnknown;
    }
  }

  /// Get localized hangul character type display from raw value
  static String hangulType(String type, AppLocalizations l10n) {
    switch (type) {
      case 'basic_consonant':
        return l10n.typeBasicConsonant;
      case 'double_consonant':
        return l10n.typeDoubleConsonant;
      case 'basic_vowel':
        return l10n.typeBasicVowel;
      case 'compound_vowel':
        return l10n.typeCompoundVowel;
      case 'final_consonant':
        return l10n.typeFinalConsonant;
      default:
        return type;
    }
  }

  /// Get localized similarity level display from score
  static String similarityLevel(double? score, AppLocalizations l10n) {
    if (score == null) return '';
    if (score >= 0.8) return l10n.similarityHigh;
    if (score >= 0.5) return l10n.similarityMedium;
    return l10n.similarityLow;
  }

  /// Format time spent as localized string
  static String timeSpent(int seconds, AppLocalizations l10n) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return l10n.timeFormatHMS(hours, minutes, secs);
    } else if (minutes > 0) {
      return l10n.timeFormatMS(minutes, secs);
    } else {
      return l10n.timeFormatS(secs);
    }
  }

  /// Get localized due status from days until review
  static String dueStatus({
    required bool isDue,
    required int daysUntilReview,
    required AppLocalizations l10n,
  }) {
    if (isDue) return l10n.dueForReviewNow;
    if (daysUntilReview == 0) return l10n.today;
    if (daysUntilReview == 1) return l10n.tomorrow;
    return l10n.daysLater(daysUntilReview);
  }
}
