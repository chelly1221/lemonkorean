# Flutter Web App Test Checklist

## Pre-Deployment
- [ ] `./build_web.sh` 실행 성공
- [ ] `../../scripts/validate_web_build.sh` 통과
- [ ] build/web/ 디렉토리 생성 확인
- [ ] main.dart.js 크기 < 10MB

## Deployment
- [ ] `docker compose restart nginx` 실행
- [ ] https://lemon.3chan.kr/app/ 접속 가능 (200 OK)
- [ ] https://lemon.3chan.kr/app/ 접속 가능 (SSL 정상)

## Functionality
- [ ] 로그인 화면 표시
- [ ] 테스트 계정 로그인 성공
- [ ] 레슨 목록 로드 (API 호출 성공)
- [ ] 레슨 상세 페이지 진입
- [ ] 중국어 간체/번체 토글 작동
- [ ] 오디오 재생 작동
- [ ] 진도 저장 (localStorage 확인)
- [ ] 설정 변경 후 새로고침 시 유지

## Browser DevTools
- [ ] Console: 치명적 에러 없음
- [ ] Network: API 호출 https://lemon.3chan.kr 사용
- [ ] Application > Local Storage: lk_* 키 존재
- [ ] Application > Service Worker: 등록됨
- [ ] Mixed Content 경고 없음

## Cross-Browser
- [ ] Chrome (Desktop)
- [ ] Firefox (Desktop)
- [ ] Safari (macOS/iOS)
- [ ] Edge (Desktop)

## Performance
- [ ] 초기 로딩 < 5초
- [ ] 페이지 전환 부드러움
- [ ] 메모리 누수 없음 (Task Manager 확인)

## PWA
- [ ] "홈 화면에 추가" 프롬프트 (모바일)
- [ ] Lighthouse PWA 점수 > 80

## Notes
날짜: ___________
테스터: ___________
브라우저: ___________
문제 발견: ___________
