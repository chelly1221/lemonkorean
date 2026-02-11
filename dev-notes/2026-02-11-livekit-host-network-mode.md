---
date: 2026-02-11
category: Infrastructure
title: LiveKit 음성 대화방 - Host 네트워크 모드 전환
author: Claude Opus 4.6
tags: [livekit, docker, webrtc, network, voice-room]
priority: high
---

## 배경

LiveKit 음성 대화방이 Docker bridge 네트워크 모드에서 WebRTC 연결 실패 문제가 지속됨.

### 근본 원인: Docker bridge 모드와 WebRTC 비호환

LiveKit은 수백 개의 UDP 포트가 필요:
- RTC: 50000-50200
- TURN relay: 30000-40000

Docker bridge 모드의 한계:
- 명시적으로 매핑된 포트(7880, 7881, 443/udp)만 노출
- 컨테이너 내부 IP(172.18.0.x)는 외부에서 도달 불가
- Hairpin NAT 실패로 SFU ↔ TURN relay 통신 불가
- `use_external_ip: true`든 `false`든 모두 실패

## 변경 사항

### 1. `docker-compose.yml` - LiveKit 서비스

```yaml
# 변경 전
livekit:
  image: livekit/livekit-server:latest
  container_name: lemon-livekit
  ports:
    - "7880:7880"
    - "7881:7881"
    - "443:443/udp"
  networks:
    - lemon-network

# 변경 후
livekit:
  image: livekit/livekit-server:latest
  container_name: lemon-livekit
  network_mode: host    # 호스트 네트워크 직접 사용
  # ports, networks 제거 (host 모드에서 불필요/불가)
```

### 2. `docker-compose.yml` - nginx, sns-service

`extra_hosts` 추가하여 `livekit` 호스트명이 Docker host gateway로 해석되도록:

```yaml
nginx:
  extra_hosts:
    - "livekit:host-gateway"

sns-service:
  extra_hosts:
    - "livekit:host-gateway"
```

이렇게 하면 기존 `upstream livekit_service { server livekit:7880; }`와
`LIVEKIT_HOST: http://livekit:7880` 설정이 변경 없이 동작.

### 3. `config/livekit/livekit.yaml` - 변경 없음

`use_external_ip: false` + host 모드 조합이 최적:
- SFU/TURN이 호스트의 로컬 IP(192.168.1.78) 사용
- LAN 클라이언트: 직접 연결
- 외부 클라이언트: TURN relay 경유 (lemon.3chan.kr:443/UDP)

## 검증 결과

- LiveKit `nodeIP: 192.168.1.78` (호스트 실제 IP 사용 확인)
- TURN 서버 UDP 443 직접 리스닝
- nginx → LiveKit: OK (extra_hosts 경유)
- SNS → LiveKit: OK (extra_hosts 경유)
- 포트 충돌 없음 (TCP 443은 NPM, UDP 443은 LiveKit)

## 데이터 흐름 (수정 후)

```
외부 클라이언트 → TURN (lemon.3chan.kr:443/UDP) → 호스트 직접 수신
  → TURN relay 할당 (192.168.1.78:3xxxx)
  → SFU가 로컬 IP로 relay 도달 ✅
  → 양방향 미디어 릴레이 성공 ✅

LAN 클라이언트 → SFU (192.168.1.78:50xxx) → 직접 연결 ✅
```
