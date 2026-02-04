---
date: 2026-02-03
category: Mobile
title: 한글 학습 모듈 종합 업그레이드
author: Claude Opus 4.5
tags: [hangul, pronunciation, writing, discrimination, shadowing, i18n]
priority: high
---

# 한글 학습 모듈 종합 업그레이드

## 개요
외국인 학습자를 위한 한글 학습 기능 7개 영역을 포괄적으로 개선했습니다.

## 구현된 기능

### Phase 1: 발음 플레이어 강화
- **파일**: `lib/presentation/screens/hangul/widgets/pronunciation_player.dart`
- 재생 속도 조절 (0.5x, 0.75x, 1x)
- 반복 재생 ON/OFF
- `just_audio` 패키지 사용

### Phase 2: 발음 메커니즘 시각화
- **새 파일**: `widgets/mouth_animation_widget.dart`
  - 입 모양 다이어그램 (5가지: closed, slightly_open, open, rounded, spread)
  - 혀 위치 다이어그램 (4가지: tip_front, tip_back, back_raised, flat)
  - 기류 타입 표시 (nasal, plosive, fricative, affricate, aspirated)
- **새 파일**: `widgets/native_comparison_card.dart`
  - 모국어별 비교 설명 (zh, ja, en, es)
  - KoreanCharacterComparisons 정적 데이터

### Phase 3: 소리 구분 훈련
- **새 파일**: `hangul_discrimination_screen.dart`
- 유사음 그룹:
  - 자음: ㄱ/ㅋ/ㄲ, ㄷ/ㅌ/ㄸ, ㅂ/ㅍ/ㅃ, ㅅ/ㅆ, ㅈ/ㅊ/ㅉ
  - 모음: ㅓ/ㅗ, ㅡ/ㅜ, ㅐ/ㅔ
- 소리 듣고 올바른 문자 선택
- 점수 및 정확도 표시

### Phase 4: 쓰기 연습 캔버스
- **새 파일**: `widgets/writing_canvas.dart`
- `perfect_freehand` 패키지 사용
- 3단계 연습:
  1. 애니메이션 보기
  2. 점선 따라 쓰기 (가이드 표시)
  3. 자유 쓰기 (정확도 측정)
- GestureDetector + CustomPaint 기반

### Phase 5: 음절 조합 훈련
- **새 파일**: `hangul_syllable_screen.dart`
  - 자음 + 모음 선택 → 즉시 소리 출력
  - 유니코드 조합: `0xAC00 + (초성 * 588) + (중성 * 28) + 종성`
  - 음절 분해 표시
- **새 파일**: `hangul_batchim_screen.dart`
  - 7대 받침 소리 그룹 연습
  - ㄱ받침, ㄴ받침, ㄷ받침, ㄹ받침, ㅁ받침, ㅂ받침, ㅇ받침

### Phase 6: 발음 녹음 및 비교 (모바일 전용)
- **새 파일**: `widgets/recording_widget.dart`
  - `record` 패키지 사용
  - 웹 플랫폼 graceful disable
- **새 파일**: `hangul_shadowing_screen.dart`
  - 4단계 흐름: 듣기 → 녹음 → 비교 → 평가
  - 자기 평가: accurate / almost / needs_practice

### Phase 7: 네비게이션 업데이트
- **수정**: `hangul_main_screen.dart`
- PopupMenuButton으로 모든 새 화면 접근
- 메뉴 항목: 쓰기 연습, 소리 구분, 음절 조합, 받침 연습, 쉐도잉

## 백엔드 API 및 DB 스키마

### Content Service (Node.js - 3002)
새 엔드포인트:
- `GET /api/content/hangul/pronunciation-guides`
- `GET /api/content/hangul/pronunciation-guides/:characterId`
- `GET /api/content/hangul/syllables`
- `GET /api/content/hangul/similar-sounds`

### PostgreSQL 스키마
새 테이블 (`database/postgres/migrations/002_add_pronunciation_guides.sql`):
- `hangul_pronunciation_guides` - 발음 가이드
- `hangul_syllables` - 음절 조합
- `hangul_similar_sound_groups` - 유사음 그룹
- `hangul_writing_progress` - 쓰기 진도
- `hangul_discrimination_progress` - 소리 구분 진도
- `hangul_pronunciation_attempts` - 발음 녹음 기록

## 다국어 지원
6개 언어에 ~60개 번역 키 추가:
- app_ko.arb (한국어)
- app_en.arb (영어)
- app_zh.arb (간체 중국어)
- app_zh_TW.arb (번체 중국어)
- app_ja.arb (일본어)
- app_es.arb (스페인어)

주요 번역 키:
- repeatEnabled/repeatDisabled
- playbackSpeed, slowSpeed, normalSpeed
- mouthShape, tonguePosition, airFlow
- soundDiscrimination, similarSoundGroups
- writingPractice, watchAnimation, traceWithGuide, freehandWriting
- syllableCombination, batchimPractice
- recordPronunciation, shadowingMode
- showMeaning, hideMeaning

## 추가된 패키지 (pubspec.yaml)
```yaml
just_audio: ^0.9.36        # 속도 조절
record: ^5.0.4             # 녹음 (모바일만)
audio_waveforms: ^1.0.5    # 파형 시각화
perfect_freehand: ^2.3.0   # 부드러운 획 렌더링
```

## HangulProvider 확장
새 메서드/게터:
- `allCharacters` - 모든 문자 목록 (characters 별칭)
- `findCharacterByChar(String char)` - 문자로 검색

## 플랫폼별 지원
| 기능 | iOS/Android | Web |
|------|-------------|-----|
| 속도 조절 | O | O |
| 발음 시각화 | O | O |
| 소리 구분 | O | O |
| 쓰기 캔버스 | O | O |
| 음절 조합 | O | O |
| 녹음/쉐도잉 | O | X (graceful disable) |

## 파일 구조
```
lib/presentation/screens/hangul/
├── hangul_discrimination_screen.dart (신규)
├── hangul_shadowing_screen.dart (신규)
├── hangul_syllable_screen.dart (신규)
├── hangul_batchim_screen.dart (신규)
├── hangul_main_screen.dart (수정)
└── widgets/
    ├── pronunciation_player.dart (수정)
    ├── writing_canvas.dart (신규)
    ├── mouth_animation_widget.dart (신규)
    ├── native_comparison_card.dart (신규)
    └── recording_widget.dart (신규)
```

## 다음 단계
1. SVG 에셋 실제 이미지로 교체 (Admin에서 업로드)
2. 발음 가이드 데이터 입력 (DB seed)
3. 음절 오디오 파일 생성
4. Progress Service 엔드포인트 구현 (Go - 3003)
