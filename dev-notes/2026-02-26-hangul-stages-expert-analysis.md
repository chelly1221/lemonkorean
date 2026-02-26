---
date: 2026-02-26
category: Mobile
title: 한글 Stage 0-11 전문가 팀 분석 리포트
author: Claude Opus 4.6
tags: [hangul, curriculum, UX, redesign, linguistics, pedagogy]
priority: high
---

# 한글 Stage 0-11 전문가 팀 분석 리포트

> 6인 전문가 팀 (Mobile UI Designer, Usability Analyst, Interaction Designer, Service Designer, 한국어학자, 언어교육학자)이 80개 레슨, 12개 스테이지 전체를 분석한 종합 보고서

---

## Executive Summary

### 커리큘럼 강점
- Stage 0-3의 모음 교수 설계가 우수 (점진적 난이도, 다양한 상호작용)
- `NativeComparisonCard`에 4개 언어별 L1 비교 데이터가 풍부하게 구축됨
- 오프라인 우선 아키텍처와 체크포인트 저장 시스템이 견고
- 한글 자질 문자 특성 활용을 위한 인프라(획순 데이터, 애니메이션)가 이미 존재
- Stage 0의 `BlockCombineIntroAnimation`이 블록 조립 개념을 효과적으로 전달

### 핵심 문제 5가지
1. **동기 절벽 (Motivation Cliff)**: Stage 7-11 (33레슨, 38%)에 미션/보상 0건
2. **상호작용 퇴화**: dragDrop/syllableBuild가 Stage 6 이후 완전 소멸, 후반부는 soundExplore+quizMcq 반복
3. **의미 맥락 부재**: 첫 단어 읽기가 75번째 레슨(Stage 11-1)에서야 등장
4. **음운 규칙 누락**: 대표음 원칙, 연음, 경음화 등 핵심 발음 규칙 미교수
5. **사실적 오류**: Stage 9-7 (부+ㅌ=붓 → 붙), Stage 9-3 (빛을 ㅊ받침 예시로 사용), 훈민정음 창제 주체 부정확

---

## PART 1: 즉시 수정 필요 사항 (사실적 오류/버그)

### BUG-1: Stage 9-7 퀴즈 오답 [한국어학자]
**파일**: `stage9_lesson_content.dart`
- `'부 + ㅌ = ?'`의 정답이 `'붓'` → **`'붙'`으로 수정** (붓은 ㅅ받침)

### BUG-2: Stage 9-3 ㅊ받침 예시 오류 [한국어학자]
**파일**: `stage9_lesson_content.dart`, `hangul_batchim_screen.dart`
- `빛`을 ㅊ받침 예시로 사용 → **`빛`은 ㅅ받침**. `빚` 또는 `닻`으로 교체

### BUG-3: Stage 5/6 미션 데이터 포맷 불일치 [Usability, Interaction]
**파일**: `step_timed_mission.dart` vs `stage5_lesson_content.dart`
- Stage 5-M, 6-M은 `questions` + `timeLimitSec` 키 사용
- `StepTimedMission` 위젯은 `consonants`/`vowels` + `timeLimitSeconds` 키만 읽음
- **미션이 기본값(ㄱ/ㄴ/ㄷ + ㅏ/ㅗ)으로 fallback되고 있을 가능성 높음**

### BUG-4: 훈민정음 창제 주체 부정확 [한국어학자]
**파일**: `stage0_lesson_content.dart`
- `'세종대왕과 집현전 학자들이 훈민정음을 만들었어요'`
- → `'세종대왕이 직접 훈민정음을 만들었어요'` (집현전은 해례본 집필)

### BUG-5: StageComplete 스텝 미사용 [Mobile UI]
- `StepType.stageComplete`이 정의되어 있으나 어떤 스테이지에서도 사용되지 않음
- 모든 스테이지 마지막 레슨에 추가 필요

---

## PART 2: 구조적 개선 (전문가 합의 사항)

### STRUCT-1: "단어 미리보기" 마일스톤 도입 [Service + 언어교육학자]
**문제**: 첫 단어 읽기가 75번째 레슨 (전체의 94%)
**합의**: 스테이지 경계마다 "이제 읽을 수 있는 단어" 미리보기 도입

| 시점 | 제시 단어 | 근거 |
|------|-----------|------|
| Stage 1 끝 | 아이(child), 우유(milk), 오이(cucumber) | 모음+ㅇ만으로 구성 |
| Stage 4 끝 | 나(I), 나무(tree), 바다(sea), 가구(furniture) | 기본자음+기본모음 |
| Stage 6 끝 | 아메리카노, 카페, 서울, 한국 | 조합+외래어 |
| Stage 8 끝 | 안녕, 한국, 밥(rice), 물(water) | 기본 받침 포함 |

### STRUCT-2: Stage 7-11에 미션 추가 [전원 합의]
**문제**: 33레슨 연속 미션 없음 → 보상 사막
**제안**:

| Stage | 미션 유형 | 시간/목표 |
|-------|-----------|-----------|
| 7 | 3중 대비 소리 구분 (가/카/까) | 120초/8문제 |
| 8 | 받침 식별 + 음절 조립 | 120초/8문제 |
| 9 | 확장 받침 종합 | 90초/6문제 |
| 10 | 겹받침 단어 읽기 | 120초/6문제 |
| 11 | 단어 속독(speed reading) | 90초/10문제 |

### STRUCT-3: 복합 모음 별도 스테이지 분리 [Usability + 언어교육학자]
**문제**: Stage 6에서 조합 훈련 + 복합 모음 7개를 2레슨에 압축 (i+5 도약)
**제안**: Stage 6을 분리
- Stage 6A: 조합 훈련 (6-1~6-5 + 미션)
- Stage 6B: 복합 모음 (ㅘ/ㅝ → ㅙ/ㅞ → ㅚ/ㅟ/ㅢ + 미션) 최소 4-5레슨

### STRUCT-4: Stage 7 레슨 확대 [언어교육학자 + Interaction]
**문제**: 된소리/거센소리 3중 대비가 5레슨뿐 (영어 화자에게 가장 어려운 항목)
**제안**: 5 → 10레슨으로 확대
- 각 대비 묶음에 최소대립쌍(달/탈/딸) 추가
- soundMatch 문항 3개 → 6-8개
- 조음 설명 (L1별 차별화) 추가

### STRUCT-5: Stage 8 받침 구조 수정 [한국어학자]
**문제**: 7대표음에 ㅅ이 포함되고 ㄷ이 빠짐
**제안**: Stage 8 받침을 `ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ` (진정한 7대표음)으로 수정
- ㅅ 받침은 Stage 9로 이동 ("ㄷ으로 발음되는 받침들" 카테고리)

### STRUCT-6: 대표음 원칙 교수 추가 [한국어학자]
**문제**: 받침 발음의 7대표음 원칙이 전혀 설명되지 않음
**제안**: Stage 8-0 도입부에 추가:
```
받침에는 7가지 대표 소리만 있어요:
ㄱ/ㅋ/ㄲ → [ㄱ], ㄴ → [ㄴ], ㄷ/ㅌ/ㅅ/ㅆ/ㅈ/ㅊ/ㅎ → [ㄷ]
ㄹ → [ㄹ], ㅁ → [ㅁ], ㅂ/ㅍ → [ㅂ], ㅇ → [ㅇ]
```

---

## PART 3: 상호작용 & UI 개선

### INT-1: 받침 블록 조립 (3-slot syllableBuild) [전원 합의]
**문제**: Stage 8-10에서 CVC 구조를 가르치면서 조립 활동이 전무
**제안**: 새로운 `StepType` 또는 `syllableBuild` 확장
```
[ㄱ] + [ㅏ] + [ㄴ] = 간   (초성 + 중성 + 종성 3칸)
```
- 기존 `SyllableBlockTemplate` (2칸)을 3칸으로 확장 필요
- Stage 8 모든 받침 레슨에 적용

### INT-2: 받침 블록 조립 애니메이션 [Mobile UI]
**문제**: Stage 0의 `BlockCombineIntroAnimation`(2조각)에 대응하는 3조각 버전 없음
**제안**: Stage 8-0에 "가 + ㄴ → 간" 3조각 조립 애니메이션 추가

### INT-3: 된소리/거센소리 3중 분류 인터랙션 [Interaction]
**제안**: 새로운 `tripletSort` StepType
- 6개 음절(가, 카, 까, 다, 타, 따)을 "평음/거센소리/된소리" 3개 버킷으로 분류
- 청각 변별의 공간-운동감각적 앵커링

### INT-4: 겹받침 분해 인터랙션 [Interaction]
**제안**: 새로운 `clusterDecompose` StepType
- 겹받침(ㄳ)을 탭하면 구성 요소(ㄱ+ㅅ)로 분리되는 애니메이션
- 어떤 요소가 발음되는지 선택하는 퀴즈

### INT-5: 획순 연습 통합 [한국어학자 + Interaction]
**현황**: `hangul_stroke_data.dart`, `stroke_order_animation.dart`, 82개 획순 에셋이 이미 존재
**문제**: Stage 0-11 교수 흐름에 통합되어 있지 않음
**제안**: Stage 1, 4, 5의 각 자모 레슨에 `StepType.tracing` 추가

### INT-6: 오디오 재생 시각 피드백 [Mobile UI]
**문제**: `StepSoundExplore`에서 TTS 재생 중 시각적 표시 없음
**제안**: 캐릭터 원에 펄스 애니메이션 + 사운드 웨이브 표시

### INT-7: 정답 축하 애니메이션 [Mobile UI]
**문제**: soundMatch/quizMcq 정답 시 색상 변경만 있고 운동감각 피드백 없음
**제안**: 정답 버튼에 스케일 팝(1.0→1.1→1.0, 300ms) + 체크마크 오버레이

### INT-8: 뒤로 가기 네비게이션 [Usability]
**문제**: 레슨 내 이전 스텝으로 돌아갈 수 없음 (NeverScrollableScrollPhysics)
**제안**: 수동 스텝(intro, soundExplore)에서 뒤로 가기 허용, 평가 스텝은 전진만

---

## PART 4: 보상 & 게이미피케이션

### GAME-1: 스트릭 시스템 [Service + Interaction]
- 연속 일일 학습 카운터
- `HangulStatsBar`에 불꽃 아이콘 표시
- 3일/7일/30일 마일스톤에 보너스 레몬
- 스트릭 동결 아이템 (레몬으로 구매)

### GAME-2: 레슨 요약에 레몬 애니메이션 표시 [Interaction]
**문제**: `LemonRewardAnimation`이 미션 결과에서만 표시됨
**사실**: 모든 레슨이 1-3 레몬을 부여하지만 summary에서 시각적으로 보이지 않음
**제안**: `StepSummary`에 미니 레몬 애니메이션 추가

### GAME-3: 스테이지 완료 보너스 레몬 [Interaction]
- 스테이지 완료 시 3-5 보너스 레몬
- `StepStageComplete` 화면에 `LemonRewardAnimation` 통합

### GAME-4: 보스 퀴즈 구현 [Service + Interaction]
**현황**: `BossQuizNode` UI 존재, `recordBossQuizBonus()` 구현됨, 퀴즈 내용 미구현
**제안**:
- 15-20문제 (전 12스테이지에서 샘플링)
- soundMatch 30% + quizMcq 30% + syllableBuild 20% + batchimBuild 20%
- 시간 제한: 300초
- 보상: 합격(70%) = 5레몬+동, 우수(85%) = 8레몬+은, 만점(95%+) = 12레몬+금

### GAME-5: SRS 복습 게임 루프 [Interaction]
**현황**: `HangulStatsBar`에 복습 알림 pill 존재, `onReviewTap` 콜백 존재, 복습 게임 없음
**제안**: 복습 pill 탭 → 5-10문제 빠른 복습 세션 (soundMatch + quizMcq)
- 완벽 복습 시 1레몬
- SRS 간격 업데이트

### GAME-6: 미션 재시도 버튼 [Usability + Interaction]
**문제**: 미션 실패 후 재시도하려면 레슨 목록으로 나갔다가 다시 들어와야 함
**제안**: `StepMissionResults`에 "다시 도전" 버튼 추가

---

## PART 5: 교수법 & 언어학 개선

### PED-1: L1 비교 데이터 레슨 흐름 통합 [언어교육학자]
**현황**: `NativeComparisonCard`에 4개 언어 데이터가 풍부하나 `hangul_character_detail.dart`에서만 사용
**제안**: 각 자모 레슨의 `StepType.intro`에서 사용자 언어 감지 → L1 비교 정보 동적 삽입
- 예: 영어 사용자에게 "Like 'g' in 'go' but unaspirated"

### PED-2: 자질 문자 체계성 교수 [언어교육학자]
**문제**: 한글의 최대 교수법적 장점(자음 형태 = 조음 위치) 미활용
**제안**: Stage 4 도입부에 조음 위치별 그룹화 시각 자료:
- 입술: ㅁ → ㅂ → ㅍ
- 혀끝: ㄴ → ㄷ → ㅌ
- 혀뿌리: ㄱ → ㅋ

### PED-3: ㅇ의 이중 역할 명시 [한국어학자]
**제안**: Stage 8-4에 추가:
`'ㅇ은 특별해요! 위에 있으면 소리가 없지만(아, 오), 아래(받침)에 있으면 "ng" 소리가 나요(방, 공)'`

### PED-4: ㅢ 특수 발음 규칙 [한국어학자]
**제안**: Stage 6-7에 추가:
- 어두: [의] (의사)
- 자음 뒤: [이] (희망→[히망])
- 조사 '의': [에] (나의→[나에])

### PED-5: 겹받침 발음 규칙 명시 [한국어학자]
**문제**: Stage 10에서 겹받침 발음 원칙 설명 없음
**제안**: Stage 10-1 도입부에:
- 왼쪽 발음: ㄳ[ㄱ], ㄵ[ㄴ], ㄶ[ㄴ], ㄻ[ㅁ], ㅄ[ㅂ]
- 오른쪽 발음: ㄺ[ㄹ], ㄼ[ㄹ] (예외: 밟다→[ㅂ])

### PED-6: 음운 규칙 입문 스테이지 신설 [한국어학자]
**제안**: Stage 11 이후 또는 Stage 11 내 통합
- 연음: 읽어→[일거], 없어→[업써]
- 경음화: 학교→[학꾜], 국밥→[국빱]
- 비음화: 국물→[궁물]
- 격음화: 좋다→[조타]

### PED-7: 레슨 콘텐츠 로컬라이제이션 [Service + 언어교육학자]
**문제**: 모든 레슨 title/description이 한국어 하드코딩
**제안**: 최소 Stage 0 콘텐츠를 AppLocalizations에 연동 (첫인상 중요)

### PED-8: 배치 테스트 (Placement Test) [언어교육학자]
**제안**: 기존 한글 지식이 있는 학습자가 적절한 Stage부터 시작할 수 있도록

---

## PART 6: 접근성 & UX 세부사항

### A11Y-1: 음성 의존 스텝 시각 대안 [Usability] — CRITICAL
**문제**: soundMatch/soundExplore가 청각 의존 (전체 스텝의 ~40%)
**제안**: 로마자 발음 표시 토글 (접근성 설정)

### A11Y-2: DragDrop 탭 대안 [Usability]
**문제**: Stage 0의 드래그앤드롭이 운동 장애 사용자에게 장벽
**제안**: 탭-선택 모드 추가 (탭 캐릭터 → 탭 슬롯)

### A11Y-3: 시맨틱 라벨 추가 [Usability]
**문제**: 모든 인터랙티브 위젯에 `Semantics` 없음 → 스크린 리더 사용 불가
**제안**: 핵심 위젯에 `Semantics` 래핑

### UX-1: 닫기 버튼 터치 타겟 [Mobile UI]
**파일**: `hangul_lesson_flow_screen.dart`
- 현재 36x36 → **48x48로 변경**

### UX-2: SoundExplore 탭 터치 타겟 [Mobile UI]
**파일**: `step_sound_explore.dart`
- 세로 패딩 8 → 14로 증가 (최소 44dp 높이 확보)

### UX-3: 재진입 컨텍스트 알림 [Usability]
**문제**: 중단 후 재접속 시 이전 학습 맥락 없이 스텝 중간에 바로 진입
**제안**: `canResume` 시 "ㅏ 모음을 배우고 있었어요. 계속할까요?" 오버레이

### UX-4: 스테이지 경로 자동 스크롤 [Mobile UI]
**문제**: `_recommendedStage` 계산되지만 스크롤 위치에 반영 안 됨
**제안**: 추천 스테이지가 화면 중앙에 오도록 자동 스크롤

---

## PART 7: 우선순위 매트릭스

### P0 — 즉시 (1주 이내)
| ID | 항목 | 난이도 |
|----|------|--------|
| BUG-1 | Stage 9-7 퀴즈 오답 수정 | Trivial |
| BUG-2 | Stage 9-3 빛→빚 교체 | Trivial |
| BUG-3 | Stage 5/6 미션 데이터 포맷 수정 | Low |
| BUG-4 | 훈민정음 창제 주체 수정 | Trivial |
| BUG-5 | stageComplete 스텝 전 스테이지 추가 | Trivial |
| UX-1 | 닫기 버튼 48px | Trivial |
| GAME-2 | Summary에 레몬 애니메이션 | Low |
| GAME-6 | 미션 재시도 버튼 | Low |

### P1 — 단기 (2-3주)
| ID | 항목 | 난이도 |
|----|------|--------|
| STRUCT-1 | 단어 미리보기 마일스톤 | Medium |
| STRUCT-2 | Stage 7-11 미션 추가 | Medium |
| STRUCT-6 | 대표음 원칙 교수 추가 | Low |
| INT-1 | 받침 3-slot syllableBuild | High |
| INT-2 | 받침 블록 조립 애니메이션 | Medium |
| INT-6 | 오디오 재생 시각 피드백 | Low |
| GAME-1 | 스트릭 시스템 | Medium |
| GAME-5 | SRS 복습 게임 루프 | Medium |
| PED-1 | L1 비교 데이터 레슨 통합 | Medium |

### P2 — 중기 (4-6주)
| ID | 항목 | 난이도 |
|----|------|--------|
| STRUCT-3 | 복합 모음 별도 스테이지 | Medium |
| STRUCT-4 | Stage 7 레슨 확대 (5→10) | High |
| STRUCT-5 | Stage 8 받침 7대표음 재편 | Medium |
| INT-3 | 된소리 3중 분류 인터랙션 | Moderate |
| INT-4 | 겹받침 분해 인터랙션 | Moderate |
| INT-5 | 획순 연습 통합 | Moderate |
| GAME-4 | 보스 퀴즈 구현 | Moderate |
| PED-2 | 자질 문자 체계성 교수 | Low |
| PED-7 | 레슨 콘텐츠 로컬라이제이션 | High |

### P3 — 장기 (2개월+)
| ID | 항목 | 난이도 |
|----|------|--------|
| PED-6 | 음운 규칙 입문 스테이지 | High |
| PED-8 | 배치 테스트 | Moderate |
| A11Y-1~3 | 접근성 전체 | High |
| INT-7 | 정답 축하 애니메이션 | Low |
| INT-8 | 뒤로 가기 네비게이션 | Medium |

---

## PART 8: 현재 vs 이상적 스테이지 구조

### 현재 구조
```
Stage 0 (4) → 1 (9) → 2 (7) → 3 (7) → 4 (7) → 5 (10) → 6 (9) → 7 (5) → 8 (9) → 9 (7) → 10 (6) → 11 (6) → BOSS
 한글구조    기본모음   Y-모음   ㅐ/ㅔ    자음1    자음2     조합+복합모음  된소리  받침1   받침확장  겹받침  단어읽기
  [미션없음]  [미션]    [미션]   [미션]  [미션없음] [미션]    [미션]      [없음]  [없음]  [없음]   [없음]  [없음]
```

### 제안 구조
```
Stage 0 (3) → 1 (9) → 2 (7) → 3 (7) → 4 (8) → 5 (8) → 6A (6) → 6B (5) → 7 (10) → 8 (9) → 9 (7) → 10 (6) → 11 (8) → 12 (5) → BOSS
 한글구조+   기본모음  Y-모음   ㅐ/ㅔ    자음(조음)  자음+혼동   조합훈련   복합모음  된소리확대  받침(7대표)  받침확장  겹받침  단어+맥락  음운규칙  종합퀴즈
 첫인사!    +첫단어!  +미션    +미션    +자질문자   +미션      +미션     +미션     +미션       +미션       +미션    +미션   +실생활    +미션
                                       활용교수
```

### 변경 핵심
1. 매 스테이지에 미션 배치 → 보상 균등 분배
2. Stage 6을 6A(조합)+6B(복합모음)으로 분리
3. Stage 7을 5→10레슨으로 확대
4. Stage 11에 실생활 맥락 Task 추가 (카페 메뉴, 지하철, 이름)
5. Stage 12 신설: 기본 음운 규칙 입문
6. 스테이지 경계마다 "단어 미리보기" 마일스톤

---

## 부록: 전문가별 고유 인사이트 요약

### Mobile UI Designer
- 후반 스테이지 레슨 깊이 퇴화 (2-3스텝 vs 초반 5-7스텝)
- 페이즈별 서브 컬러 도입 권고 (모음=파랑, 자음=오렌지, 조합=보라, 받침=틸)
- `_LessonCard` 위젯이 12개 파일에 복붙 → 공유 위젯 추출

### Usability Analyst
- 힌트 콘텐츠(`빛` 오류)에서 콘텐츠 팩트체크 부재 확인
- 색상 대비 실패: 힌트 텍스트 #F9A825 on #FFF9C4 (비율 2.1:1, WCAG AA 미달)
- 레슨 step 수 편차 과도 (2~7스텝) → 최소 4스텝 보장

### Interaction Designer
- 참여 곡선 정량 분석: Stage 6 이후 cliff 확인
- DragDrop이 Stage 0에서만 3회 사용 후 완전 폐기 — 가장 매력적인 인터랙션의 낭비
- 리뷰 nudge pill이 "UI dead end" — onReviewTap 콜백이 리뷰 게임으로 연결 안 됨

### Service Designer
- Time-to-value: ~10.5시간 후 첫 단어 (경쟁 앱은 30분 이내)
- "커뮤니티에 성취 공유" 버튼 부재 → 소셜 바이럴 루프 단절
- 보스 퀴즈 노드가 "준비 중입니다" snackbar → 80레슨 완주 후 막다른 길

### 한국어학자
- Stage 8 ㅅ받침의 실제 음가[ㄷ] 미설명 (7대표음 원칙 누락)
- ㅢ의 3가지 위치별 발음 규칙 미교수
- 자모 명칭(기역/니은/디귿) 체계적 교수 부재
- Stage 0의 초성-중성 구조만 설명, CVC(종성) 예고 없음

### 언어교육학자
- Output(말하기/쓰기) 활동 전무 — 전체 등급 F
- Task-based 활동 전무 — 전체 등급 F
- L1 비교 데이터가 레슨 흐름에 미통합 — 가장 아까운 미활용 자산
- 총 소요 시간 추정: 약 184분(3시간 4분), 하루 15분 기준 12-13일
- "중간 탈주" 위험 구간: Stage 4-6 (아직 단어 못 읽는데 레슨만 계속)
