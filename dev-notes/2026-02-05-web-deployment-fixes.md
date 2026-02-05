---
date: 2026-02-05
category: Infrastructure
title: 웹 배포 시스템 PATH 및 WebAssembly 호환성 수정
author: Claude Sonnet 4.5
tags: [deployment, flutter, web, systemd, wasm]
priority: high
---

# 웹 배포 시스템 PATH 및 WebAssembly 호환성 수정

## 개요

웹 배포 시스템의 연속적인 실패(배포 #7, #8)를 분석하고 두 가지 주요 문제를 해결했습니다:
1. Deploy agent가 Flutter 명령어를 찾지 못하는 PATH 문제
2. Flutter 패키지들의 WebAssembly 비호환성 문제

## 문제 분석

### 배포 #7 실패: Flutter 명령어 없음
**증상**:
```
flutter: 명령어를 찾을 수 없음
Exit code: 127
```

**원인**:
- systemd 서비스는 기본적으로 최소한의 환경 변수만 제공
- 사용자의 `.bashrc`나 `.profile`을 로드하지 않음
- Flutter SDK가 사용자 PATH에 설치되어 있어 systemd에서 접근 불가

### 배포 #8 실패: WebAssembly 호환성
**증상**:
```
Error: Unsupported operation: dart:html
Error: dart:ffi is not supported on this platform
package:win32 - requires dart:ffi
```

**원인**:
- Flutter 3.22+ 버전은 기본적으로 WebAssembly 컴파일 시도
- 다음 패키지들이 wasm과 비호환:
  - `flutter_secure_storage_web` (dart:html, dart:js_util 사용)
  - `share_plus` (dart:html, dart:ffi 사용)
  - `audioplayers_web` (dart:html 사용)
  - `connectivity_plus` (dart:html 사용)
  - `win32` (dart:ffi 광범위 사용, 웹에 불필요)

## 해결 방법

### 수정 #1: systemd 서비스 로그인 셸 사용

**파일**: `/etc/systemd/system/lemon-deploy-agent.service`

**변경 내용**:
```ini
# 이전
[Service]
ExecStart=/bin/bash /home/sanchan/lemonkorean/scripts/deploy-trigger/deploy-agent.sh

# 이후
[Service]
ExecStart=/bin/bash -l /home/sanchan/lemonkorean/scripts/deploy-trigger/deploy-agent.sh
```

**설명**:
- `-l` 플래그로 bash를 로그인 셸로 실행
- `/etc/profile`, `~/.bash_profile`, `~/.bashrc` 등에서 사용자 환경 로드
- Flutter SDK가 포함된 PATH를 정상적으로 로드

**적용 방법**:
```bash
sudo systemctl daemon-reload
sudo systemctl restart lemon-deploy-agent
```

### 수정 #2: WebAssembly 비활성화

**파일**: `/home/sanchan/lemonkorean/mobile/lemon_korean/build_web.sh`

**변경 내용**:
```bash
# 이전 (line 13)
flutter build web --release

# 이후
flutter build web --release --no-wasm
```

**설명**:
- `--no-wasm` 플래그로 JavaScript 컴파일 강제
- JavaScript는 모든 브라우저 API 접근 가능
- 현재 사용 중인 모든 Flutter 패키지와 호환

**기술적 배경**:
- **WebAssembly**: 더 빠른 성능, 작은 번들, 제한된 브라우저 API
- **JavaScript**: 모든 웹 API 접근, 모든 패키지 호환, 약간 큰 번들
- **선택**: 패키지 호환성과 안정성 우선

## 구현 세부사항

### systemd 서비스 수정 스크립트
자동화 스크립트로 수정 적용:
- 원본 서비스 파일 백업
- `-l` 플래그 추가한 새 서비스 파일 생성
- systemd 데몬 리로드 및 서비스 재시작

**백업 위치**: `/etc/systemd/system/lemon-deploy-agent.service.backup.20260205-125813`

### Flutter 빌드 스크립트 수정
`build_web.sh`의 Flutter 빌드 명령어에 `--no-wasm` 플래그 추가
- 약 9-10분의 빌드 시간 예상
- JavaScript 번들 생성으로 모든 패키지 정상 작동

## 테스트 계획

### 배포 프로세스 확인
1. Admin 대시보드에서 새 배포 시작
2. 실시간 로그 모니터링
3. 진행 상태 확인: pending → building → deploying → completed
4. 최종 배포된 앱 접근 테스트

### 모니터링 명령어
```bash
# Deploy agent 로그
journalctl -u lemon-deploy-agent -f

# 배포 상태 확인
docker compose exec -T postgres psql -U 3chan -d lemon_korean -c \
  "SELECT id, status, progress FROM web_deployments ORDER BY id DESC LIMIT 1;"

# Trigger 디렉토리 확인
ls -la /home/sanchan/lemonkorean/services/admin/src/deploy-triggers/
```

### 성공 기준
- ✅ "flutter: 명령어를 찾을 수 없음" 에러 없음
- ✅ WebAssembly 호환성 에러 없음
- ✅ 배포 진행률 100% 도달
- ✅ 상태: "completed"
- ✅ https://lemon.3chan.kr/app/ 정상 접근

## 영향 범위

### 변경된 파일
1. `/etc/systemd/system/lemon-deploy-agent.service` - systemd 서비스 정의
2. `/home/sanchan/lemonkorean/mobile/lemon_korean/build_web.sh` - Flutter 빌드 스크립트

### 영향 받는 시스템
- Deploy agent systemd 서비스
- 웹 앱 빌드 프로세스
- Flutter 웹 번들 생성 방식 (wasm → js)

### 영향 받지 않는 부분
- 모바일 앱 빌드 (Android/iOS)
- 기존 배포된 웹 앱 (다음 배포부터 적용)
- 백엔드 서비스
- 데이터베이스

## 잠재적 문제 및 대응

### 문제 1: JavaScript 번들 크기 증가
**예상**: WebAssembly 대비 10-20% 번들 크기 증가 가능
**대응**: 성능 영향 미미, CDN 캐싱으로 로딩 최적화
**모니터링**: 빌드 후 `build/web` 디렉토리 크기 확인

### 문제 2: 로그인 셸 로딩 시간
**예상**: 서비스 시작 시 추가 환경 로딩 시간
**대응**: 한 번만 로딩되므로 실질적 영향 없음
**모니터링**: `systemctl status lemon-deploy-agent`로 시작 시간 확인

### 문제 3: PATH 변경 시 재시작 필요
**예상**: Flutter SDK 경로 변경 시 서비스 재시작 필요
**대응**: SDK 경로는 고정이므로 변경 가능성 낮음
**조치**: 변경 시 `systemctl restart lemon-deploy-agent` 실행

## 향후 개선 사항

### 단기 (1-2주)
1. **배포 테스트 자동화**: 배포 후 자동 health check 추가
2. **에러 복구**: 배포 실패 시 자동 재시도 로직
3. **알림 시스템**: 배포 완료/실패 시 알림 전송

### 중기 (1-2개월)
1. **빌드 캐싱**: Flutter 빌드 캐시로 빌드 시간 단축
2. **병렬 배포**: 여러 환경(dev/staging/prod) 동시 배포 지원
3. **롤백 기능**: 이전 버전으로 즉시 롤백 가능한 메커니즘

### 장기 (3-6개월)
1. **CI/CD 통합**: GitHub Actions 또는 GitLab CI와 통합
2. **무중단 배포**: Blue-Green 배포로 다운타임 제거
3. **성능 모니터링**: 배포된 앱의 성능 메트릭 수집 및 분석

## 참고 문서

- Flutter Web Build Modes: https://docs.flutter.dev/platform-integration/web/building
- WebAssembly Support: https://docs.flutter.dev/platform-integration/web/wasm
- systemd Service Configuration: https://www.freedesktop.org/software/systemd/man/systemd.service.html

## 관련 이슈

- 배포 #7 실패: Flutter 명령어 PATH 문제
- 배포 #8 실패: WebAssembly 호환성 문제
- GitHub Issue: [해당사항 없음 - 내부 배포 시스템]

## 체크리스트

- [x] systemd 서비스 파일 수정 및 백업
- [x] Flutter 빌드 스크립트 수정
- [x] Deploy agent 서비스 재시작
- [x] 서비스 상태 확인
- [ ] 새 배포 테스트 실행
- [ ] 배포 성공 확인
- [ ] 웹 앱 접근 테스트
- [ ] 문서 업데이트 (`WEB_DEPLOYMENT_GUIDE.md`)

## 결론

두 가지 핵심 문제를 해결하여 웹 배포 시스템의 안정성을 크게 향상시켰습니다:
1. systemd 서비스의 로그인 셸 사용으로 Flutter PATH 접근 보장
2. JavaScript 컴파일로 모든 Flutter 패키지 호환성 확보

다음 배포 테스트를 통해 수정 사항의 효과를 검증하고, 성공 시 배포 시스템이 안정적으로 작동할 것으로 예상됩니다.

---

**작성일**: 2026-02-05
**작성자**: Claude Sonnet 4.5
**다음 단계**: 웹 배포 테스트 실행 및 결과 확인
