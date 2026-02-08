---
date: 2026-02-07
category: Frontend
title: 웹 앱 로딩 화면을 Flutter 스플래시와 동일하게 통합
author: Claude Sonnet 4.5
tags: [web, ui/ux, splash-screen, branding]
priority: medium
---

## 문제점

웹 앱에서 두 개의 로딩 화면이 순차적으로 표시되어 UX가 저하됨:

1. **HTML 로딩 화면** (index.html): Flutter 프레임워크 로딩 중 표시되는 일반적인 "로딩 중..." 스피너
2. **Flutter 스플래시 화면** (main.dart): 브랜드화된 레몬 로고 화면 (2초 인증/동기화 딜레이)

사용자는 일반 로더를 본 후 브랜드 스플래시 화면을 보게 되어 중복되고 비전문적인 경험을 받음.

## 해결 방법

HTML 로딩 화면을 Flutter 스플래시 화면과 완전히 동일하게 재구현하여 전환이 보이지 않도록 함.

### 주요 변경사항

**파일**: `/home/sanchan/lemonkorean/mobile/lemon_korean/web/index.html` (lines 27-97)

**Flutter 스플래시 스펙 (main.dart lines 237-306)**:
- 배경색: #FFEF5F (레몬 옐로우)
- 화이트 라운드 컨테이너: 120x120px, border-radius 30px
- 레몬 이모지: 🍋 (60px 폰트)
- 박스 섀도우: rgba(0,0,0,0.1), 20px blur, 10px Y-offset
- 타이틀: "Lemon Korean" (32px, bold, #001F3F)
- 서브타이틀: "레몬 한국어" (20px, #003366)
- 간격: 30px (로고-타이틀), 10px (타이틀-서브타이틀), 50px (서브타이틀-로더)
- 화이트 원형 진행 표시기

### 구현된 HTML/CSS

```html
<style>
  body {
    margin: 0;
    padding: 0;
    background: #FFEF5F;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  }

  .splash {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    text-align: center;
  }

  .logo-container {
    width: 120px;
    height: 120px;
    background: white;
    border-radius: 30px;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 30px;
  }

  .lemon-emoji {
    font-size: 60px;
    line-height: 1;
  }

  .title {
    font-size: 32px;
    font-weight: bold;
    color: #001F3F;
    margin: 0 0 10px 0;
  }

  .subtitle {
    font-size: 20px;
    color: #003366;
    margin: 0 0 50px 0;
  }

  .spinner {
    width: 40px;
    height: 40px;
    border: 4px solid rgba(255, 255, 255, 0.3);
    border-top-color: white;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 0 auto;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }
</style>

<div class="splash">
  <div class="logo-container">
    <div class="lemon-emoji">🍋</div>
  </div>
  <h1 class="title">Lemon Korean</h1>
  <p class="subtitle">레몬 한국어</p>
  <div class="spinner"></div>
</div>
```

## 결과

- ✅ 단일하고 일관된 스플래시 화면 경험
- ✅ HTML→Flutter 전환 시 시각적으로 보이지 않음
- ✅ 전문적이고 브랜드화된 첫 인상
- ✅ 레이아웃 시프트나 깜박임 없음

## 테스트

```bash
# 웹 앱 재빌드 및 배포
cd /home/sanchan/lemonkorean/mobile/lemon_korean
./build_web.sh

# 브라우저 테스트
1. https://lemon.3chan.kr/app/ 접속
2. 캐시 삭제 및 하드 새로고침 (Ctrl+Shift+R)
3. 로딩 중 단일 스플래시 화면만 표시되는지 확인
4. HTML→Flutter 전환 시 시각적 변화가 없는지 확인
```

## 기술적 세부사항

**CSS 전략**:
- `position: fixed` + `transform: translate(-50%, -50%)`로 정확한 중앙 정렬
- Flexbox로 레몬 이모지 센터링
- CSS 애니메이션으로 부드러운 스피너 회전
- 픽셀 단위 측정값과 색상값이 Flutter 구현과 정확히 일치

**브라우저 호환성**:
- 모든 모던 브라우저 지원 (CSS3 필요)
- 이모지 렌더링은 시스템 폰트에 의존
- 폴백 폰트 스택으로 일관된 타이포그래피 보장

## 관련 파일

- `/mobile/lemon_korean/web/index.html` - HTML 스플래시 구현
- `/mobile/lemon_korean/lib/main.dart` (lines 237-306) - Flutter 스플래시 참조
- `/mobile/lemon_korean/lib/core/constants/app_constants.dart` (line 41) - primaryColor 정의

## 향후 고려사항

- Flutter 스플래시 디자인 변경 시 HTML 버전도 동기화 필요
- 로딩 시간이 매우 짧을 경우 스플래시가 깜박일 수 있음 (최소 표시 시간 추가 고려)
- 프로그레시브 웹 앱(PWA) 설치 시 스플래시 화면이 별도로 처리됨 (manifest.json의 icons 사용)
