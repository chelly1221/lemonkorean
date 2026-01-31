---
date: 2026-01-30
category: Documentation
title: 개발노트 시스템 초기화
author: Claude Sonnet 4.5
tags: [기능, 문서, admin-dashboard]
priority: medium
---

# 개발노트 시스템

## 개요
Lemon Korean admin 대시보드를 위한 포괄적인 개발노트 시스템을 구현했습니다. 이 기능은 frontmatter 메타데이터가 포함된 마크다운 기반 개발 로그를 볼 수 있게 합니다.

## 문제 / 배경
이전에는 개발 노트와 중요한 기술적 결정들이 커밋 메시지와 문서 파일에 흩어져 있었습니다. 시간순으로 개발 로그나 기술적 결정을 볼 수 있는 중앙화된 장소가 없었습니다.

## 해결 방법 / 구현
admin 대시보드에 다음 기능을 가진 새로운 "개발노트" 탭을 생성했습니다:

1. **마크다운 저장**: `/dev-notes/` 디렉토리에 `.md` 파일로 노트 저장
2. **Frontmatter 메타데이터**: 구조화된 데이터를 위한 YAML frontmatter (날짜, 카테고리, 우선순위, 태그)
3. **이중 뷰 모드**:
   - **타임라인 뷰**: 최신 노트가 먼저 나오는 시간순 목록
   - **카테고리 뷰**: 필터 드롭다운이 있는 카테고리별 그룹화
4. **읽기 전용 인터페이스**: 노트는 파일 시스템에서 편집하고 대시보드에서 조회

## 변경된 파일

### 백엔드 (신규 파일)
- `/services/admin/src/controllers/dev-notes.controller.js` - 메인 컨트롤러
- `/services/admin/src/routes/dev-notes.routes.js` - API 라우트

### 백엔드 (수정)
- `/services/admin/src/index.js` - 새 라우트 등록
- `/services/admin/package.json` - js-yaml 의존성 추가

### 프론트엔드 (신규 파일)
- `/services/admin/public/js/pages/dev-notes.js` - 페이지 컴포넌트

### 프론트엔드 (수정)
- `/services/admin/public/js/api-client.js` - devNotes API 추가
- `/services/admin/public/js/components/sidebar.js` - 메뉴 항목 추가
- `/services/admin/public/js/router.js` - 라우트 등록
- `/services/admin/public/index.html` - 스크립트 로드

### 문서
- `/home/sanchan/lemonkorean/CLAUDE.md` - 개발노트 가이드 추가

## 아키텍처

### Frontmatter 구조
```yaml
---
date: 2026-01-30
category: Mobile|Backend|Frontend|Database|Infrastructure|Documentation
title: 노트 제목
author: 작성자 이름
tags: [태그1, 태그2]
priority: high|medium|low
---
```

### API 엔드포인트
```
GET /api/admin/dev-notes           - 메타데이터를 포함한 모든 노트 목록
GET /api/admin/dev-notes/content   - 특정 노트 내용 조회
GET /api/admin/dev-notes/categories - 고유 카테고리 조회
```

### 프론트엔드 컴포넌트
- **개발노트 페이지**: 분할 레이아웃이 있는 메인 페이지
- **노트 목록**: 뷰 토글 및 필터링이 있는 사이드바
- **노트 뷰어**: 구문 강조 표시가 있는 마크다운 렌더링

## 코드 예시

### Frontmatter 파싱 (백엔드)
```javascript
const yaml = require('js-yaml');

function parseFrontmatter(content) {
  const frontmatterRegex = /^---\s*\n([\s\S]*?)\n---\s*\n([\s\S]*)$/;
  const match = content.match(frontmatterRegex);

  if (!match) {
    return { metadata: {}, content };
  }

  const metadata = yaml.load(match[1]);
  const markdownContent = match[2];

  return { metadata, content: markdownContent };
}
```

### 뷰 토글 (프론트엔드)
```javascript
function renderViewToggle() {
  return `
    <div class="btn-group mb-3" role="group">
      <button class="btn ${currentView === 'timeline' ? 'btn-primary' : 'btn-outline-primary'}"
              data-view="timeline">
        시간순
      </button>
      <button class="btn ${currentView === 'category' ? 'btn-primary' : 'btn-outline-primary'}"
              data-view="category">
        카테고리
      </button>
    </div>
  `;
}
```

## 테스트

### 백엔드 테스트
```bash
# 노트 목록
curl http://localhost:3006/api/admin/dev-notes \
  -H "Authorization: Bearer YOUR_TOKEN"

# 노트 내용 조회
curl "http://localhost:3006/api/admin/dev-notes/content?path=dev-notes/2026-01-30-example.md" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 프론트엔드 테스트
1. http://localhost:3006 접속
2. 관리자로 로그인
3. 사이드바에서 "개발노트" 클릭
4. 타임라인과 카테고리 뷰 전환
5. 카테고리별 필터링
6. 노트 클릭하여 내용 보기
7. 마크다운 렌더링 확인

## 관련 이슈 / 참고사항

### 보안 고려사항
- 경로 정제를 통한 디렉토리 탐색 공격 방지
- 모든 엔드포인트에 관리자 인증 필수
- 읽기 전용 접근 (UI에서 파일 생성/수정 불가)

### 성능
- 노트 목록은 프론트엔드 상태에 캐시
- 마크다운 파싱은 클라이언트 측에서 수행 (Marked.js)
- 파일 시스템 읽기는 동기식 (적은 수의 노트에서 허용 가능)

### 향후 개선사항
- 노트 전체 텍스트 검색
- PDF로 노트 내보내기
- 버전 히스토리를 위한 Git 통합
- 커밋 메시지에서 자동 노트 생성
- 노트에 댓글 스레드 추가

## 배운 교훈

1. **Frontmatter의 강력함**: YAML frontmatter는 데이터베이스 없이도 구조화된 메타데이터를 제공함
2. **읽기 전용이 충분함**: 개발 노트의 경우, 파일 시스템 편집이 전체 CRUD UI를 구축하는 것보다 효율적임
3. **뷰 모드의 중요성**: 시간순 및 카테고리별 뷰는 서로 다른 사용 사례에 적합함
4. **Bootstrap 컴포넌트**: Bootstrap의 내장 컴포넌트(카드, 배지, 버튼) 사용으로 일관성 보장

## 참고자료

- Marked.js 문서: https://marked.js.org/
- js-yaml 라이브러리: https://github.com/nodeca/js-yaml
- Bootstrap 5 컴포넌트: https://getbootstrap.com/docs/5.3/
- Admin 대시보드 아키텍처: `/services/admin/DASHBOARD.md`
