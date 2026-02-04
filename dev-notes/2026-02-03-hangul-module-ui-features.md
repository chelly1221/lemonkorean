---
date: 2026-02-03
category: Mobile
title: 한글 학습 모듈 UI 기능 구현
author: Claude Opus 4.5
tags: [hangul, audio, practice, share, flutter]
priority: high
---

# 한글 학습 모듈 UI 기능 구현

## 개요
한글 학습 모듈에 3가지 미구현 UI 기능을 구현했습니다.

## 변경 사항

### 1. 오디오 재생 기능 (pronunciation_player.dart)
- `audioplayers` 패키지를 사용하여 실제 오디오 재생 구현
- 기존의 500ms 딜레이 시뮬레이션을 실제 URL 오디오 재생으로 교체
- `AudioPlayer` 인스턴스 관리 및 `dispose()` 메서드 추가

```dart
final AudioPlayer _audioPlayer = AudioPlayer();

Future<void> _playAudio() async {
  final audioUrl = '${AppConstants.mediaUrl}/${widget.character.audioUrl}';
  await _audioPlayer.play(UrlSource(audioUrl));
  await _audioPlayer.onPlayerComplete.first;
}
```

### 2. 캐릭터별 연습 기능 (hangul_practice_screen.dart, hangul_character_detail.dart)
- `HangulPracticeScreen`에 `focusCharacter` 파라미터 추가
- 특정 캐릭터 선택 시 해당 캐릭터만 5회 반복 연습
- "연습 시작" 버튼 클릭 시 해당 캐릭터 연습 화면으로 이동

### 3. 공유 기능 (hangul_character_detail.dart)
- `share_plus` 패키지 추가 (pubspec.yaml)
- 캐릭터 정보 (문자, 로마자, 발음, 예시 단어) 공유 가능
- 해시태그 `#LemonKorean #柠檬韩语` 포함

## 수정된 파일
| 파일 | 변경 내용 |
|------|---------|
| `pubspec.yaml` | `share_plus: ^7.2.1` 추가 |
| `widgets/pronunciation_player.dart` | AudioPlayer 구현, dispose 추가 |
| `hangul_character_detail.dart` | share 기능, practice 네비게이션 |
| `hangul_practice_screen.dart` | focusCharacter 파라미터 추가 |

## 검증 방법
1. **오디오**: 캐릭터 상세 화면 > 재생 버튼 탭 > 발음 재생 확인
2. **연습**: 캐릭터 상세 화면 > "연습 시작" 탭 > 해당 캐릭터 퀴즈 시작
3. **공유**: 캐릭터 상세 화면 > 공유 아이콘 탭 > 시스템 공유 시트 표시

## 참고 사항
- 오디오 파일은 백엔드 MinIO에 존재해야 함 (`character.audioUrl`)
- `character.hasAudio`가 false면 재생 버튼 표시되지 않음
