---
date: 2026-02-03
category: Mobile
title: 레슨 스테이지 국제화 완료
author: Claude Opus 4.5
tags: [i18n, l10n, flutter, lesson-stages]
priority: medium
---

# 레슨 스테이지 국제화 완료

## 개요
레슨 화면의 7단계(Intro, Vocabulary, Grammar, Practice, Dialogue, Quiz, Summary)에서 하드코딩된 중국어 문자열을 국제화 시스템으로 마이그레이션했습니다.

## 변경된 파일

### ARB 파일 (모든 6개 언어)
- `lib/l10n/app_zh.arb` - 중국어 간체 (템플릿)
- `lib/l10n/app_en.arb` - 영어
- `lib/l10n/app_ko.arb` - 한국어
- `lib/l10n/app_ja.arb` - 일본어
- `lib/l10n/app_es.arb` - 스페인어
- `lib/l10n/app_zh_TW.arb` - 중국어 번체

### 스테이지 파일
1. `vocabulary_stage.dart` - 8개 UI 라벨 교체
   - 汉字词 → l10n.hanjaWord
   - 点击返回 → l10n.tapToFlipBack
   - 与中文相似度 → l10n.similarityWithChinese
   - 유사도 힌트 문자열 4개

2. `grammar_stage.dart` - 9개 UI 라벨 교체
   - 语法讲解 → l10n.grammarExplanation
   - 规则 → l10n.rules
   - 🇰🇷 韩语 → l10n.koreanLanguage
   - 🇨🇳 中文 → l10n.chineseLanguage
   - 例句 → l10n.exampleSentences
   - 例 {n} → l10n.exampleNumber(n)
   - 练习 → l10n.practice
   - 填空： → l10n.fillInBlankPrompt
   - 太棒了！→ l10n.excellent

3. `stage3_grammar.dart` - 6개 UI 라벨 교체
   - BilingualText 위젯을 l10n 호출로 교체

4. `stage4_practice.dart` - 7개 UI 라벨 교체
   - 太棒了！答对了！ → l10n.correctFeedback
   - 不对哦，再想想看 → l10n.incorrectFeedback
   - 네비게이션 버튼 문자열

5. `stage5_dialogue.dart` - 1개 UI 라벨 교체
   - 上一个 → l10n.previousItem

6. `stage7_summary.dart` - 완전한 국제화
   - BilingualText/InlineBilingualText 위젯 제거
   - 모든 문자열을 l10n 시스템 사용으로 변경
   - _buildAchievementCard, _buildStatItem 메서드 시그니처 간소화

## 추가된 l10n 키 (17개)
```
hanjaWord - 한자어 라벨
tapToFlipBack - 카드 뒤집기 힌트
similarityWithChinese - 중국어 유사도 라벨
hanjaWordSimilarPronunciation - 유사도 힌트 (높음)
sameEtymologyEasyToRemember - 유사도 힌트 (중간-높음)
someConnection - 유사도 힌트 (중간)
nativeWordNeedsMemorization - 유사도 힌트 (낮음)
rules - 규칙 라벨
koreanLanguage - 한국어 라벨 (국기 포함)
chineseLanguage - 중국어 라벨 (국기 포함)
exampleNumber - 예제 번호 (매개변수화)
fillInBlankPrompt - 빈칸 채우기 프롬프트
correctFeedback - 정답 피드백
incorrectFeedback - 오답 피드백
allStagesPassed - 모든 단계 통과 메시지
continueToLearnMore - 더 학습하기 메시지
```

## 기술적 구현

### 메서드 시그니처 변경
`AppLocalizations l10n` 매개변수를 빌드 메서드에서 헬퍼 메서드로 전달:
```dart
Widget _buildBackCard(Map<String, dynamic> word, AppLocalizations l10n)
Widget _buildSimilarityBar(int similarity, AppLocalizations l10n)
String _getSimilarityHint(int similarity, AppLocalizations l10n)
Widget _buildGrammarPoint(Map<String, dynamic> point, int pointIndex, AppLocalizations l10n)
```

### BilingualText 위젯 제거
기존:
```dart
const BilingualText(
  chinese: '课程完成！',
  korean: '수업 완료!',
  chineseStyle: TextStyle(...),
)
```

변경 후:
```dart
Text(
  l10n.lessonComplete,
  style: const TextStyle(...),
)
```

## 검증
- `flutter gen-l10n` 실행 완료
- `flutter analyze` - 에러 없음 (deprecation 경고만 존재)
- 6개 언어 모두 새 키 추가 완료

## 남은 작업 (선택사항)
- 데이터 모델의 표시 문자열 국제화 (vocabulary_model.dart, progress_model.dart 등)
- withOpacity deprecation 경고 수정 (withValues() 사용)
