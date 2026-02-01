---
date: 2026-02-01
category: Infrastructure
title: Favicon 및 앱 아이콘 업데이트 (레몬 캐릭터)
author: Claude Opus 4.5
tags: [favicon, app-icon, branding, web, android, admin]
priority: medium
---

# Favicon 및 앱 아이콘 업데이트

## 개요
새로운 레몬 캐릭터 이미지를 사용하여 모든 플랫폼(Web, Android, Admin Dashboard)의 favicon 및 앱 아이콘을 업데이트했습니다.

## 배경/문제
- 기존 아이콘은 기본 Flutter 아이콘이었음
- 브랜드 아이덴티티를 강화하기 위해 귀여운 레몬 캐릭터로 교체 필요
- Admin 대시보드에는 favicon이 없었음

## 해결책/구현

### 소스 이미지
- URL: `https://lemon.3chan.kr/media/images/1d7a3edcfb430371c51bb664c8158ddd.png`
- 크기: 512x512 PNG (RGBA)
- 특징: 파란 배경에 귀여운 레몬 캐릭터

### Python 스크립트로 아이콘 생성
Pillow 라이브러리를 사용하여 모든 필요한 크기의 아이콘 생성

```python
from PIL import Image

def generate_icon(source, output_path, size):
    img = source.copy()
    img = img.resize((size, size), Image.Resampling.LANCZOS)
    img.save(output_path, "PNG", optimize=True)
```

## 변경된 파일

### Flutter Web App (5개 파일)
| 파일 | 크기 | 용도 |
|------|------|------|
| `mobile/lemon_korean/web/favicon.png` | 16x16 | 브라우저 탭 아이콘 |
| `mobile/lemon_korean/web/icons/Icon-192.png` | 192x192 | PWA 아이콘 |
| `mobile/lemon_korean/web/icons/Icon-512.png` | 512x512 | 대형 PWA 아이콘 |
| `mobile/lemon_korean/web/icons/Icon-maskable-192.png` | 192x192 | 적응형 아이콘 |
| `mobile/lemon_korean/web/icons/Icon-maskable-512.png` | 512x512 | 적응형 아이콘 |

### Android App (5개 파일)
| 파일 | 크기 | 용도 |
|------|------|------|
| `mipmap-mdpi/ic_launcher.png` | 48x48 | 중간 밀도 |
| `mipmap-hdpi/ic_launcher.png` | 72x72 | 고밀도 |
| `mipmap-xhdpi/ic_launcher.png` | 96x96 | 초고밀도 |
| `mipmap-xxhdpi/ic_launcher.png` | 144x144 | 초초고밀도 |
| `mipmap-xxxhdpi/ic_launcher.png` | 192x192 | 초초초고밀도 |

### Admin Dashboard (3개 파일)
| 파일 | 크기 | 용도 |
|------|------|------|
| `services/admin/public/favicon.ico` | 32x32 | ICO 형식 favicon |
| `services/admin/public/favicon.png` | 32x32 | PNG 형식 favicon |
| `services/admin/public/index.html` | - | favicon 링크 추가 |

## 코드 예시

### Admin index.html 변경
```html
<!-- Before -->
<title>柠檬韩语 - 관리자 페이지</title>

<!-- Bootstrap 5.3 CSS -->

<!-- After -->
<title>柠檬韩语 - 관리자 페이지</title>

<!-- Favicon -->
<link rel="icon" type="image/x-icon" href="favicon.ico">
<link rel="icon" type="image/png" href="favicon.png">

<!-- Bootstrap 5.3 CSS -->
```

## 테스트

### Favicon 접근 확인
```bash
# Web App favicon
curl -sI "https://lemon.3chan.kr/app/favicon.png"
# HTTP/2 200, content-type: image/png, content-length: 780

# Admin favicon
curl -sI "https://lemon.3chan.kr/admin/favicon.ico"
# HTTP/2 200, content-type: image/x-icon, content-length: 2022

# PWA 아이콘
curl -sI "https://lemon.3chan.kr/app/icons/Icon-192.png"
# HTTP/2 200, content-type: image/png, content-length: 25579
```

### 브라우저 확인
1. https://lemon.3chan.kr/app/ - 브라우저 탭에 레몬 캐릭터 아이콘 표시
2. https://lemon.3chan.kr/admin/ - 브라우저 탭에 레몬 캐릭터 아이콘 표시

### Android 앱 확인
- APK 재빌드 후 기기에서 앱 아이콘 확인 필요
- `flutter build apk --release`

## 배포 단계
1. Python 스크립트로 아이콘 생성
2. Flutter Web 빌드: `flutter build web`
3. Nginx 재시작: `docker compose restart nginx`

## 관련 노트
- 소스 이미지는 MinIO 미디어 서버에 저장되어 있음
- maskable 아이콘은 원본 이미지의 패딩이 충분하여 별도 처리 없이 사용
- 기존 theme color (#FFC107 amber)는 변경하지 않음
