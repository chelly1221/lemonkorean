---
date: 2026-02-04
category: Frontend
title: Admin 사이드바 중첩 메뉴 섹션 구현
author: Claude Sonnet 4.5
tags: [admin, ui, sidebar, navigation]
priority: medium
---

## 개요
관리자 대시보드의 사이드바 네비게이션을 개선하여 메뉴 항목들을 논리적 그룹으로 구성했습니다. 기존의 플랫한 메뉴 구조를 섹션 기반으로 재구성하여 가독성과 사용성을 향상시켰습니다.

## 변경 사항

### 1. 메뉴 구조 개편
**파일**: `/services/admin/public/js/components/sidebar.js`

#### Before (플랫 구조)
```javascript
const menuItems = [
  { path: '/dashboard', icon: 'fa-th-large', label: '대시보드' },
  { path: '/users', icon: 'fa-users', label: '사용자 관리' },
  { path: '/lessons', icon: 'fa-pen-to-square', label: '레슨 관리' },
  // ... 11개 항목
];
```

#### After (섹션 기반 구조)
```javascript
const menuSections = [
  {
    type: 'single',
    items: [
      { path: '/dashboard', icon: 'fa-th-large', label: '대시보드' }
    ]
  },
  {
    type: 'group',
    label: '사용자',
    items: [
      { path: '/users', icon: 'fa-users', label: '사용자 관리' }
    ]
  },
  {
    type: 'group',
    label: '자료관리',
    icon: 'fa-database',
    items: [
      { path: '/lessons', icon: 'fa-pen-to-square', label: '레슨 관리' },
      { path: '/vocabulary', icon: 'fa-language', label: '단어 관리' },
      { path: '/hangul', icon: 'fa-font', label: '한글 자모' },
      { path: '/media', icon: 'fa-images', label: '미디어 관리' }
    ]
  },
  {
    type: 'group',
    label: '서비스 관리',
    icon: 'fa-cogs',
    items: [
      { path: '/system', icon: 'fa-cog', label: '시스템 모니터링' },
      { path: '/deploy', icon: 'fa-rocket', label: '웹 배포' }
    ]
  },
  {
    type: 'group',
    label: '개발',
    icon: 'fa-code',
    items: [
      { path: '/services', icon: 'fa-cubes', label: '서비스 현황' },
      { path: '/docs', icon: 'fa-book', label: '개발 문서' },
      { path: '/dev-notes', icon: 'fa-sticky-note', label: '개발노트' }
    ]
  }
];
```

### 2. render() 함수 업데이트
섹션 타입에 따라 다른 HTML 구조를 생성하도록 수정:
- `type: 'single'`: 섹션 헤더 없이 항목만 렌더링
- `type: 'group'`: 섹션 헤더 + 항목들 렌더링

```javascript
const menuHTML = menuSections
  .map((section) => {
    if (section.type === 'single') {
      // 단일 항목 렌더링
      return section.items.map(item => ...).join('');
    } else if (section.type === 'group') {
      // 섹션 헤더 + 항목들 렌더링
      return `
        <div class="sidebar-section">
          <div class="sidebar-section-header">
            ${sectionIcon}
            <span>${section.label}</span>
          </div>
          ${itemsHTML}
        </div>
      `;
    }
  })
  .join('');
```

### 3. updateActive() 함수 수정
섹션 구조에서 모든 항목을 추출하도록 변경:
```javascript
const allItems = menuSections.flatMap(section => section.items);
```

### 4. CSS 스타일 추가
**파일**: `/services/admin/public/css/admin.css`

```css
/* Menu Section */
.sidebar-section {
  margin-bottom: 1rem;
}

.sidebar-section-header {
  padding: 0.5rem 1.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: #95a5a6; /* Muted gray */
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.5rem;
}

.sidebar-section-header i {
  font-size: 0.7rem;
}

/* Indent items within sections */
.sidebar-section .sidebar-menu-item {
  padding-left: 2rem;
}
```

## 메뉴 섹션 구성

1. **대시보드** (단일 항목)
   - 대시보드

2. **사용자**
   - 사용자 관리

3. **자료관리** (아이콘: database)
   - 레슨 관리
   - 단어 관리
   - 한글 자모
   - 미디어 관리

4. **서비스 관리** (아이콘: cogs)
   - 시스템 모니터링
   - 웹 배포

5. **개발** (아이콘: code)
   - 서비스 현황
   - 개발 문서
   - 개발노트

## 디자인 결정

### 정적 섹션 선택
- 확장/축소 기능은 구현하지 않음 (향후 확장 가능)
- 모든 섹션이 항상 표시되어 접근성 향상
- 단순한 시각적 그룹핑으로 충분히 효과적

### 스타일링 접근
- 섹션 헤더: 대문자 + 작은 폰트 + 회색 색상 (시각적 계층 구조)
- 섹션 항목: 왼쪽 들여쓰기 (2rem) 적용
- 섹션 아이콘: 선택적 사용 (현재는 주요 섹션에만 적용)

## 영향 범위
- **파일 변경**: 2개 (sidebar.js, admin.css)
- **라인 수정**: ~100 라인
- **Breaking Changes**: 없음 (하위 호환성 유지)
- **기존 기능**: 모든 라우팅 및 활성 상태 로직 정상 작동

## 테스트 방법

### 1. 시각적 확인
```bash
# 관리자 대시보드 접속
http://localhost:3006
```

확인 사항:
- ✅ 섹션 헤더가 올바르게 표시됨
- ✅ 항목들이 섹션별로 그룹화됨
- ✅ 들여쓰기가 적절히 적용됨
- ✅ 섹션 아이콘이 표시됨

### 2. 기능 테스트
- 각 메뉴 항목 클릭 시 정상 작동
- 활성 상태(노란색 왼쪽 테두리) 올바르게 표시
- URL 직접 입력 시에도 활성 상태 정상 작동
- 페이지 새로고침 시 활성 상태 유지

### 3. 반응형 테스트
- 모바일 뷰에서도 섹션 헤더 표시
- 들여쓰기가 작은 화면에서도 적절히 작동

## 향후 개선 사항

1. **확장/축소 기능**
   - localStorage를 사용한 섹션 상태 유지
   - 각 섹션 헤더에 토글 버튼 추가

2. **시각적 구분**
   - 섹션 사이에 구분선 추가 고려
   - 섹션 헤더 호버 효과 추가

3. **접근성 개선**
   - ARIA 속성 추가 (role, aria-label)
   - 키보드 네비게이션 최적화

## 기술적 고려사항

### 확장성
- 새 섹션 추가가 용이 (menuSections 배열에 객체 추가)
- 섹션 타입 확장 가능 (예: 'collapsible' 타입)

### 유지보수성
- 데이터 구조와 렌더링 로직 분리
- 타입 기반 조건부 렌더링으로 명확한 로직

### 성능
- 클라이언트 사이드 렌더링만 사용
- 추가적인 네트워크 요청 없음
- DOM 조작 최소화

## 참고
- 관련 이슈: Admin sidebar navigation organization
- 영향받는 서비스: Admin Dashboard (port 3006)
- 테스트 환경: Chrome/Firefox/Safari
