---
date: 2026-02-11
category: Infrastructure
title: LiveKit TURN 비활성화 - 직접 연결 방식으로 전환
author: Claude Opus 4.6
tags: [livekit, turn, webrtc, network]
priority: high
---

## 변경 내용

TURN relay가 지속적으로 문제를 일으켜 비활성화하고, 클라이언트가 SFU에 직접 연결하는 방식으로 전환.

### `config/livekit/livekit.yaml` 변경

```yaml
# 변경 전
rtc:
  use_external_ip: false
turn:
  enabled: true
  domain: lemon.3chan.kr
  udp_port: 443

# 변경 후
rtc:
  use_external_ip: true      # STUN으로 공인 IP 탐지 → ICE 후보에 포함
turn:
  enabled: false              # TURN 비활성화
```

## 동작 방식

- `use_external_ip: true` → STUN 서버를 통해 공인 IP(112.156.95.110) 탐지
- LiveKit이 공인 IP를 ICE 후보로 광고 (`nodeIP: 112.156.95.110`)
- 외부 클라이언트는 공인 IP:50000-50200(UDP)으로 직접 연결
- LAN 클라이언트는 192.168.1.78:50000-50200으로 직접 연결

## 라우터 포트포워딩 필요

| 포트 | 프로토콜 | 용도 |
|------|----------|------|
| UDP 50000-50200 | UDP | RTC 미디어 (필수) |
| TCP 7881 | TCP | RTC TCP 폴백 (권장) |
| ~~UDP 443~~ | ~~UDP~~ | ~~TURN~~ (더 이상 불필요) |

## 검증 결과

- LiveKit 재시작 후 `nodeIP: 112.156.95.110` 확인 (이전: `192.168.1.78`)
- TURN 관련 로그 없음
- UDP 443 더 이상 리스닝하지 않음 (TCP 443은 NPM이 사용 중 - 정상)
- 재시작 직후 Flutter 클라이언트(user_53) 연결 성공 확인
