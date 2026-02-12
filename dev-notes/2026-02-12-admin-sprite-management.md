---
date: 2026-02-12
category: Backend|Frontend
title: Admin 대시보드 스프라이트 파일 관리 기능 구현
author: Claude Opus 4.6
tags: [admin, sprite, character-items, minio, upload]
priority: medium
---

## 개요
Admin 대시보드의 Character Items 페이지에 스프라이트 파일 업로드, 애니메이션 미리보기, 프레임 메타데이터 설정 기능을 추가했다.

## 변경 파일 (4개)

### Backend
1. **`services/admin/src/routes/character-items.routes.js`**
   - `multer` 추가 (PNG만 허용, 10MB 제한, memoryStorage)
   - `upload-asset` 라우트 -> `upload-sprite` 라우트로 교체, `upload.single('sprite')` 미들웨어 적용
   - multer 에러 핸들러 추가

2. **`services/admin/src/controllers/character-items.controller.js`**
   - 깨진 `getMinIOClient` import -> `media-upload.service` import으로 교체
   - placeholder `uploadAsset` -> 실제 `uploadSprite` 함수로 교체
   - MinIO에 `sprites/{category}/{hash}.png`로 업로드
   - `itemId` 전달 시 해당 아이템의 `metadata.spritesheet_key` 자동 업데이트 + `asset_type='spritesheet'` 설정

### Frontend
3. **`services/admin/public/js/api-client.js`**
   - `characterItemsAPI`에 `uploadSprite(formData)` 메서드 추가 (FormData + Bearer token)

4. **`services/admin/public/js/pages/character-items.js`**
   - 아이템 카드에 스프라이트 썸네일 추가 (CSS background-position으로 첫 프레임 표시)
   - 생성/수정 모달을 `modal-lg`로 확장, 2열 레이아웃 (기본 필드 | 스프라이트 섹션)
   - Asset Type에 `spritesheet` 옵션 추가, 선택 시 스프라이트 섹션 토글
   - Canvas 기반 애니메이션 미리보기 (3x 스케일, 8fps, Front/Back/Right 방향 전환)
   - 프레임 메타데이터 입력 (frameWidth, frameHeight, frameColumns, frameRows)
   - 저장 시 spritesheet 메타데이터를 기존 metadata와 merge

## 기술 노트
- 스프라이트 이미지 URL: `/media/sprites/{category}/{hash}.png` (media 서비스를 통해 서빙)
- 카드 썸네일은 `image-rendering: pixelated`로 픽셀아트 선명하게 표시
- 애니메이션은 `requestAnimationFrame` 기반, 모달 닫힐 때 `cancelAnimationFrame`으로 정리
- 기존 `media-upload.service.js`의 `uploadFile()` 재사용, type을 `sprites/{category}`로 전달
