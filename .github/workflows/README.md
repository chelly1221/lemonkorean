# CI/CD 파이프라인

GitHub Actions를 사용한 자동화된 빌드, 테스트, 배포 파이프라인.

## 워크플로우 개요

### CI Pipeline (`ci.yml`)

**트리거:**
- `main`, `develop` 브랜치에 push
- Pull Request 생성/업데이트

**작업:**
1. **Test Node.js Services** - Auth, Content, Admin 서비스 테스트
2. **Test Go Services** - Progress, Media 서비스 테스트
3. **Test Python Services** - Analytics 서비스 테스트
4. **Lint and Format** - 코드 스타일 검사
5. **Build Docker Images** - 모든 서비스 Docker 이미지 빌드
6. **Security Scan** - Trivy 취약점 스캔

**실행 시간:** ~10-15분

### CD Pipeline (`cd.yml`)

**트리거:**
- `main` 브랜치에 push
- 버전 태그 push (`v1.0.0`)

**작업:**
1. **Build and Push** - Docker 이미지 빌드 및 Container Registry에 push
2. **Deploy to Production** - 프로덕션 서버에 배포
3. **Database Backup** - 배포 후 자동 백업
4. **Notification** - Slack 알림 전송

**실행 시간:** ~15-20분

## 필요한 Secrets

GitHub 저장소 Settings → Secrets에서 설정:

### 필수
```
GITHUB_TOKEN                 # 자동 제공됨 (Container Registry용)
```

### 프로덕션 배포 (선택)
```
PROD_HOST                    # 프로덕션 서버 IP/도메인
PROD_USERNAME                # SSH 사용자명
PROD_SSH_KEY                 # SSH 개인 키
```

### 알림 (선택)
```
SLACK_WEBHOOK                # Slack Incoming Webhook URL
```

### AWS S3 백업 (선택)
```
AWS_ACCESS_KEY_ID           # AWS Access Key
AWS_SECRET_ACCESS_KEY       # AWS Secret Key
```

## 로컬에서 워크플로우 테스트

[act](https://github.com/nektos/act) 사용:

```bash
# act 설치 (macOS)
brew install act

# CI 워크플로우 실행
act pull_request

# 특정 job만 실행
act -j test-node-services

# Secrets 파일 사용
act --secret-file .secrets
```

## 배포 프로세스

### 1. 개발 → PR → 테스트

```bash
# Feature 브랜치 생성
git checkout -b feature/new-feature

# 코드 작성 및 커밋
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# PR 생성 → CI 자동 실행
```

### 2. PR 승인 → Main 머지

```bash
# PR 승인 후 merge
# → CI + CD 자동 실행
# → Docker 이미지 빌드
# → 프로덕션 배포 (설정된 경우)
```

### 3. 릴리즈 태그

```bash
# 버전 태그 생성
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# → CI + CD 실행
# → 버전별 Docker 이미지 생성
```

## Docker 이미지 태그 전략

```
ghcr.io/username/lemon-korean-auth:main
ghcr.io/username/lemon-korean-auth:v1.0.0
ghcr.io/username/lemon-korean-auth:1.0
ghcr.io/username/lemon-korean-auth:main-abc1234
```

## 배포 환경 설정

### GitHub Environments

Settings → Environments → New environment

**Production 환경:**
- Required reviewers: 관리자 승인 필요
- Deployment branches: `main`만 허용
- Environment secrets: 프로덕션 전용 secrets

**Staging 환경 (선택):**
- Required reviewers: 없음
- Deployment branches: `develop` 허용

## 수동 배포

GitHub Actions UI에서 수동 트리거:

1. Actions 탭 이동
2. "CD Pipeline" 선택
3. "Run workflow" 클릭
4. 브랜치 선택 및 실행

## 롤백 절차

### 자동 롤백

배포 실패 시 자동으로 이전 버전으로 롤백됩니다.

### 수동 롤백

```bash
# SSH로 프로덕션 서버 접속
ssh user@prod-server

# 이전 커밋으로 롤백
cd /opt/lemon-korean
git log --oneline -n 10  # 커밋 이력 확인
git checkout <previous-commit-hash>
docker-compose pull
docker-compose up -d
```

## 모니터링

### GitHub Actions 상태

- 대시보드: https://github.com/username/lemonkorean/actions
- 배지: ![CI Status](https://github.com/username/lemonkorean/workflows/CI%20Pipeline/badge.svg)

### 알림

- ✅ 성공: Slack 알림 (녹색)
- ❌ 실패: Slack 알림 (빨간색) + 이메일

### 로그 확인

```bash
# GitHub Actions 로그는 웹 UI에서 확인
# 또는 gh CLI 사용
gh run list
gh run view <run-id>
gh run view <run-id> --log
```

## 최적화

### 캐싱

```yaml
# Node.js 의존성 캐싱
- uses: actions/setup-node@v4
  with:
    cache: 'npm'

# Docker 레이어 캐싱
- uses: docker/build-push-action@v5
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### 병렬 실행

Matrix strategy로 서비스별 병렬 테스트:

```yaml
strategy:
  matrix:
    service: [auth, content, admin]
```

### 조건부 실행

```yaml
# main 브랜치에서만 배포
if: github.ref == 'refs/heads/main'

# PR에서만 실행
if: github.event_name == 'pull_request'
```

## 보안

### Secrets 관리

- ❌ 절대 코드에 하드코딩하지 않기
- ✅ GitHub Secrets 사용
- ✅ Environment별로 분리

### 권한 최소화

```yaml
permissions:
  contents: read    # 코드 읽기만
  packages: write   # Container Registry 쓰기만
```

### 취약점 스캔

Trivy가 자동으로 스캔하고 GitHub Security 탭에 리포트:

1. Actions → CI Pipeline → Security Scan
2. Security 탭 → Code scanning alerts

## 문제 해결

### CI 실패 시

```bash
# 로컬에서 동일한 환경으로 테스트
docker-compose -f docker-compose.test.yml up -d
npm test

# 의존성 문제
rm -rf node_modules package-lock.json
npm install
```

### 배포 실패 시

```bash
# 서버 로그 확인
ssh user@prod-server
docker-compose logs -f

# 서비스 상태 확인
docker-compose ps
curl http://localhost/health
```

### 이미지 pull 실패

```bash
# Container Registry 로그인 확인
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# 이미지 수동 pull
docker pull ghcr.io/username/lemon-korean-auth:main
```

## 추가 개선 사항

- [ ] E2E 테스트 추가
- [ ] 성능 테스트 자동화
- [ ] Blue-Green 배포
- [ ] Canary 배포
- [ ] Kubernetes 지원
- [ ] Multi-region 배포

## 참고 자료

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [SSH Action](https://github.com/appleboy/ssh-action)

## 문의

CI/CD 관련 문의:
- GitHub Issues
- DevOps 팀: devops@lemonkorean.com
