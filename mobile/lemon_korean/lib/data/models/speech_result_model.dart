/// Speech result data models.
///
/// Re-exports the canonical types from pronunciation_scorer.dart
/// for convenient access from UI and provider layers.
library speech_result_model;

export '../../core/services/pronunciation_scorer.dart'
    show SpeechResult, PhonemeScoreDetail, SpeechGrade;
