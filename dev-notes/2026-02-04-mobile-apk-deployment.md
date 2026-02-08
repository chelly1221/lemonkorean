---
date: 2026-02-04
category: Mobile
title: 모바일 APK 빌드 및 배포
author: Claude Sonnet 4.5
tags: [mobile, apk, deployment, android]
priority: medium
---

# 모바일 APK 빌드 및 배포

## 개요
Flutter 코드 품질 경고 정리 및 웹 API 마이그레이션 완료 후 모바일 APK 빌드 및 무선 ADB 설치.

---

## 빌드

```bash
flutter build apk --release
# ✓ Built build/app/outputs/flutter-apk/app-release.apk (67.4MB)
# Build time: 951.1s (15분 51초)
# Tree-shaking: MaterialIcons 1.64MB → 15.7KB (99.0% 감소)
```

## 설치

```bash
# 무선 ADB 디바이스 확인
adb devices
# adb-RFCX60MTPPW-h9knqn._adb-tls-connect._tcp device

# APK 설치
adb install -r build/app/outputs/flutter-apk/app-release.apk
# Success
```

## 웹 배포 (동시 수행)

```bash
flutter build web --release --no-wasm-dry-run  # 164.3초, 35.03 MB
rsync -av --delete build/web/ /mnt/nas/lemon/flutter-build/build/web/
docker compose restart nginx
# 접속: https://lemon.3chan.kr/app/
```

## Wasm 제약사항
현재 Wasm 미지원 패키지로 인해 JavaScript 빌드 사용 (`--no-wasm-dry-run`):
- `flutter_secure_storage_web`, `audioplayers_web` (dart:html 의존)
- `share_plus` (dart:ffi 의존), `connectivity_plus` (dart:html 의존)

---

## 테스트 체크리스트
- ✅ APK 설치 성공
- ✅ 웹 앱 접속 확인

**배포 완료**: 2026-02-04
