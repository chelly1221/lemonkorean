/**
 * Admin API Client
 *
 * 모든 Admin Service API를 래핑하는 중앙화된 클라이언트
 *
 * 주요 기능:
 * - 자동 JWT 토큰 주입 (Authorization 헤더)
 * - 401 에러 시 자동 로그인 페이지 리디렉션
 * - 에러 처리 및 사용자 친화적 메시지
 * - 재시도 로직 (네트워크 에러)
 *
 * 사용 예시:
 * const users = await API.users.list({ page: 1, limit: 10 });
 * const lesson = await API.lessons.getById(123);
 */

const API = (() => {
  // Base URL (환경에 따라 변경 가능)
  const BASE_URL = window.location.origin;

  /**
   * HTTP 요청 헬퍼 함수
   *
   * @param {string} endpoint - API 엔드포인트 (예: '/api/admin/users')
   * @param {Object} options - fetch 옵션
   * @param {string} options.method - HTTP 메서드 (GET, POST, PUT, DELETE)
   * @param {Object} options.body - 요청 본문 (JSON으로 변환됨)
   * @param {Object} options.headers - 추가 헤더
   * @param {boolean} options.skipAuth - 인증 헤더 제외 여부 (기본값: false)
   * @returns {Promise<Object>} API 응답 데이터
   */
  async function request(endpoint, options = {}) {
    const { method = 'GET', body, headers = {}, skipAuth = false } = options;

    // 기본 헤더 설정
    const defaultHeaders = {
      'Content-Type': 'application/json',
    };

    // JWT 토큰 주입 (로그인 제외)
    if (!skipAuth && Auth.isAuthenticated()) {
      defaultHeaders['Authorization'] = `Bearer ${Auth.getToken()}`;
    }

    // 요청 옵션 구성
    const fetchOptions = {
      method,
      headers: { ...defaultHeaders, ...headers },
    };

    // Body 추가 (GET 요청 제외)
    if (body && method !== 'GET') {
      fetchOptions.body = JSON.stringify(body);
    }

    try {
      // API 호출
      const response = await fetch(`${BASE_URL}${endpoint}`, fetchOptions);

      // 401 Unauthorized → 로그인 페이지로
      if (response.status === 401 && !skipAuth) {
        Auth.logout();
        window.location.hash = '#/login';
        throw new Error('인증이 만료되었습니다. 다시 로그인해주세요.');
      }

      // 204 No Content (삭제 성공 등)
      if (response.status === 204) {
        return { success: true };
      }

      // JSON 파싱
      const data = await response.json();

      // 에러 응답 처리
      if (!response.ok) {
        throw new Error(data.error || data.message || '요청 처리 중 오류가 발생했습니다.');
      }

      return data;
    } catch (error) {
      // 네트워크 에러 처리
      if (error.name === 'TypeError' && error.message.includes('fetch')) {
        throw new Error('서버에 연결할 수 없습니다. 네트워크 상태를 확인해주세요.');
      }

      // 기타 에러
      throw error;
    }
  }

  /**
   * 쿼리 파라미터를 URL 인코딩된 문자열로 변환
   *
   * @param {Object} params - 쿼리 파라미터 객체
   * @returns {string} URL 인코딩된 쿼리 문자열 (예: '?page=1&limit=10')
   *
   * @example
   * buildQueryString({ page: 1, search: 'test' })
   * // 반환값: '?page=1&search=test'
   */
  function buildQueryString(params) {
    if (!params || Object.keys(params).length === 0) return '';

    const query = Object.entries(params)
      .filter(([_, value]) => value !== undefined && value !== null && value !== '')
      .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
      .join('&');

    return query ? `?${query}` : '';
  }

  // =============================================================================
  // Auth API
  // =============================================================================

  const authAPI = {
    /**
     * 로그인
     *
     * @param {Object} credentials - 로그인 정보
     * @param {string} credentials.email - 이메일
     * @param {string} credentials.password - 비밀번호
     * @returns {Promise<{token: string, user: Object}>} JWT 토큰 및 사용자 정보
     */
    async login(credentials) {
      return request('/api/admin/auth/login', {
        method: 'POST',
        body: credentials,
        skipAuth: true,
      });
    },

    /**
     * 로그아웃
     *
     * @returns {Promise<Object>} 성공 메시지
     */
    async logout() {
      return request('/api/admin/auth/logout', { method: 'POST' });
    },

    /**
     * 토큰 갱신
     *
     * @returns {Promise<{token: string}>} 새 JWT 토큰
     */
    async refresh() {
      return request('/api/admin/auth/refresh', { method: 'POST' });
    },

    /**
     * 현재 사용자 프로필 조회
     *
     * @returns {Promise<Object>} 사용자 정보
     */
    async getProfile() {
      return request('/api/admin/auth/profile');
    },
  };

  // =============================================================================
  // Users API
  // =============================================================================

  const usersAPI = {
    /**
     * 사용자 목록 조회
     *
     * @param {Object} params - 쿼리 파라미터
     * @param {number} params.page - 페이지 번호 (기본값: 1)
     * @param {number} params.limit - 페이지당 항목 수 (기본값: 10)
     * @param {string} params.search - 검색어 (이메일/이름)
     * @param {string} params.subscription - 구독 타입 (free/premium)
     * @param {string} params.status - 상태 (active/inactive)
     * @returns {Promise<{data: Array, pagination: Object}>} 사용자 목록 및 페이지네이션
     */
    async list(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/users${queryString}`);
    },

    /**
     * 사용자 상세 조회
     *
     * @param {number} userId - 사용자 ID
     * @returns {Promise<Object>} 사용자 상세 정보
     */
    async getById(userId) {
      return request(`/api/admin/users/${userId}`);
    },

    /**
     * 사용자 정보 수정
     *
     * @param {number} userId - 사용자 ID
     * @param {Object} data - 수정할 데이터
     * @returns {Promise<Object>} 수정된 사용자 정보
     */
    async update(userId, data) {
      return request(`/api/admin/users/${userId}`, {
        method: 'PUT',
        body: data,
      });
    },

    /**
     * 사용자 밴/언밴
     *
     * @param {number} userId - 사용자 ID
     * @param {Object} data - 밴 정보
     * @param {boolean} data.banned - 밴 여부
     * @param {string} data.ban_reason - 밴 사유
     * @returns {Promise<Object>} 업데이트된 사용자 정보
     */
    async ban(userId, data) {
      return request(`/api/admin/users/${userId}/ban`, {
        method: 'PUT',
        body: data,
      });
    },

    /**
     * 사용자 삭제
     *
     * @param {number} userId - 사용자 ID
     * @returns {Promise<Object>} 성공 메시지
     */
    async delete(userId) {
      return request(`/api/admin/users/${userId}`, {
        method: 'DELETE',
      });
    },

    /**
     * 사용자 활동 로그 조회
     *
     * @param {number} userId - 사용자 ID
     * @param {Object} params - 쿼리 파라미터
     * @returns {Promise<Array>} 활동 로그 목록
     */
    async getActivity(userId, params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/users/${userId}/activity${queryString}`);
    },

    /**
     * 사용자 감사 로그 조회
     *
     * @param {number} userId - 사용자 ID
     * @returns {Promise<Array>} 감사 로그 목록
     */
    async getAuditLogs(userId) {
      return request(`/api/admin/users/${userId}/audit-logs`);
    },
  };

  // =============================================================================
  // Lessons API
  // =============================================================================

  const lessonsAPI = {
    /**
     * 레슨 목록 조회
     *
     * @param {Object} params - 쿼리 파라미터
     * @param {number} params.page - 페이지 번호
     * @param {number} params.limit - 페이지당 항목 수
     * @param {string} params.level - 레벨 필터
     * @param {string} params.status - 상태 필터 (draft/published/archived)
     * @returns {Promise<{data: Array, pagination: Object}>} 레슨 목록 및 페이지네이션
     */
    async list(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/lessons${queryString}`);
    },

    /**
     * 레슨 상세 조회
     *
     * @param {number} lessonId - 레슨 ID
     * @returns {Promise<Object>} 레슨 상세 정보
     */
    async getById(lessonId) {
      return request(`/api/admin/lessons/${lessonId}`);
    },

    /**
     * 레슨 생성
     *
     * @param {Object} data - 레슨 데이터
     * @param {number} data.level - 레벨
     * @param {string} data.title_ko - 한국어 제목
     * @param {string} data.title_zh - 중국어 제목
     * @param {string} data.description - 설명
     * @param {string} data.difficulty - 난이도
     * @param {number} data.estimated_duration - 소요 시간 (분)
     * @param {Object} data.content - 콘텐츠 JSON
     * @returns {Promise<Object>} 생성된 레슨
     */
    async create(data) {
      return request('/api/admin/lessons', {
        method: 'POST',
        body: data,
      });
    },

    /**
     * 레슨 수정
     *
     * @param {number} lessonId - 레슨 ID
     * @param {Object} data - 수정할 데이터
     * @returns {Promise<Object>} 수정된 레슨
     */
    async update(lessonId, data) {
      return request(`/api/admin/lessons/${lessonId}`, {
        method: 'PUT',
        body: data,
      });
    },

    /**
     * 레슨 삭제
     *
     * @param {number} lessonId - 레슨 ID
     * @returns {Promise<Object>} 성공 메시지
     */
    async delete(lessonId) {
      return request(`/api/admin/lessons/${lessonId}`, {
        method: 'DELETE',
      });
    },

    /**
     * 레슨 발행
     *
     * @param {number} lessonId - 레슨 ID
     * @returns {Promise<Object>} 발행된 레슨
     */
    async publish(lessonId) {
      return request(`/api/admin/lessons/${lessonId}/publish`, {
        method: 'PUT',
      });
    },

    /**
     * 레슨 미발행
     *
     * @param {number} lessonId - 레슨 ID
     * @returns {Promise<Object>} 미발행된 레슨
     */
    async unpublish(lessonId) {
      return request(`/api/admin/lessons/${lessonId}/unpublish`, {
        method: 'PUT',
      });
    },

    /**
     * 레슨 일괄 발행
     *
     * @param {Array<number>} lessonIds - 레슨 ID 배열
     * @returns {Promise<Object>} 성공 메시지
     */
    async bulkPublish(lessonIds) {
      return request('/api/admin/lessons/bulk/publish', {
        method: 'PUT',
        body: { lessonIds },
      });
    },

    /**
     * 레슨 일괄 삭제
     *
     * @param {Array<number>} lessonIds - 레슨 ID 배열
     * @returns {Promise<Object>} 성공 메시지
     */
    async bulkDelete(lessonIds) {
      return request('/api/admin/lessons/bulk/delete', {
        method: 'DELETE',
        body: { lessonIds },
      });
    },

    /**
     * 레슨 콘텐츠 조회 (MongoDB)
     *
     * @param {number} lessonId - 레슨 ID
     * @returns {Promise<Object>} 7단계 레슨 콘텐츠
     */
    async getContent(lessonId) {
      return request(`/api/admin/lessons/${lessonId}/content`);
    },

    /**
     * 레슨 콘텐츠 저장 (MongoDB)
     *
     * @param {number} lessonId - 레슨 ID
     * @param {Object} content - 7단계 콘텐츠 데이터
     * @returns {Promise<Object>} 성공 메시지
     */
    async saveContent(lessonId, content) {
      return request(`/api/admin/lessons/${lessonId}/content`, {
        method: 'PUT',
        body: content,
      });
    },
  };

  // =============================================================================
  // Vocabulary API
  // =============================================================================

  const vocabularyAPI = {
    /**
     * 단어 목록 조회
     *
     * @param {Object} params - 쿼리 파라미터
     * @param {number} params.page - 페이지 번호
     * @param {number} params.limit - 페이지당 항목 수
     * @param {string} params.search - 검색어 (한국어/중국어)
     * @param {string} params.level - 레벨 필터
     * @returns {Promise<{data: Array, pagination: Object}>} 단어 목록 및 페이지네이션
     */
    async list(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/vocabulary${queryString}`);
    },

    /**
     * 단어 상세 조회
     *
     * @param {number} vocabularyId - 단어 ID
     * @returns {Promise<Object>} 단어 상세 정보
     */
    async getById(vocabularyId) {
      return request(`/api/admin/vocabulary/${vocabularyId}`);
    },

    /**
     * 단어 생성
     *
     * @param {Object} data - 단어 데이터
     * @param {string} data.korean - 한국어
     * @param {string} data.hanja - 한자
     * @param {string} data.chinese - 중국어
     * @param {string} data.pinyin - 병음
     * @param {string} data.part_of_speech - 품사
     * @param {number} data.level - 레벨
     * @param {string} data.audio_url - 오디오 URL
     * @returns {Promise<Object>} 생성된 단어
     */
    async create(data) {
      return request('/api/admin/vocabulary', {
        method: 'POST',
        body: data,
      });
    },

    /**
     * 단어 수정
     *
     * @param {number} vocabularyId - 단어 ID
     * @param {Object} data - 수정할 데이터
     * @returns {Promise<Object>} 수정된 단어
     */
    async update(vocabularyId, data) {
      return request(`/api/admin/vocabulary/${vocabularyId}`, {
        method: 'PUT',
        body: data,
      });
    },

    /**
     * 단어 삭제
     *
     * @param {number} vocabularyId - 단어 ID
     * @returns {Promise<Object>} 성공 메시지
     */
    async delete(vocabularyId) {
      return request(`/api/admin/vocabulary/${vocabularyId}`, {
        method: 'DELETE',
      });
    },

    /**
     * 단어 일괄 삭제
     *
     * @param {Array<number>} vocabularyIds - 단어 ID 배열
     * @returns {Promise<Object>} 성공 메시지
     */
    async bulkDelete(vocabIds) {
      return request('/api/admin/vocabulary/bulk-delete', {
        method: 'POST',
        body: { vocabIds },
      });
    },

    /**
     * 엑셀 파일로 단어 일괄 업로드
     *
     * @param {FormData} formData - 엑셀 파일 데이터
     * @returns {Promise<Object>} 업로드 결과
     */
    async bulkUpload(formData, mode = 'skip') {
      const token = Auth.getToken();

      const response = await fetch(`${BASE_URL}/api/admin/vocabulary/bulk-upload?mode=${mode}`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
        },
        body: formData,
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.message || 'Bulk upload failed');
      }

      return response.json();
    },

    /**
     * 엑셀 템플릿 다운로드
     *
     * @returns {Promise<void>} 파일 다운로드 시작
     */
    async downloadTemplate() {
      try {
        const token = Auth.getToken();

        if (!token) {
          throw new Error('인증 토큰이 없습니다. 다시 로그인해주세요.');
        }

        console.log('[API] Downloading template...');

        const response = await fetch(`${BASE_URL}/api/admin/vocabulary/template`, {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${token}`,
          },
        });

        console.log('[API] Template response status:', response.status);

        if (!response.ok) {
          let errorMessage = 'Failed to download template';
          try {
            const error = await response.json();
            console.error('[API] Template error:', error);
            errorMessage = error.message || error.error || errorMessage;
          } catch (e) {
            // JSON 파싱 실패 시 기본 메시지 사용
            errorMessage = `서버 오류 (${response.status})`;
          }
          throw new Error(errorMessage);
        }

        // Get filename from Content-Disposition header or use default
        const disposition = response.headers.get('Content-Disposition');
        let filename = 'vocabulary_template.xlsx';
        if (disposition && disposition.includes('filename=')) {
          filename = disposition.split('filename=')[1].replace(/['"]/g, '');
        }

        // Download file
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.style.display = 'none';
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();

        // Cleanup
        setTimeout(() => {
          window.URL.revokeObjectURL(url);
          document.body.removeChild(a);
        }, 100);

        console.log('[API] Template downloaded successfully');
      } catch (error) {
        console.error('[API] Template download error:', error);
        throw error;
      }
    },
  };

  // =============================================================================
  // Media API
  // =============================================================================

  const mediaAPI = {
    /**
     * 미디어 목록 조회
     *
     * @param {Object} params - 쿼리 파라미터
     * @param {string} params.type - 파일 타입 (images/audio/video/documents)
     * @returns {Promise<Array>} 미디어 파일 목록
     */
    async list(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/media${queryString}`);
    },

    /**
     * 미디어 업로드
     *
     * @param {FormData} formData - 파일 데이터 (multipart/form-data)
     * @returns {Promise<Object>} 업로드된 파일 정보 (URL 포함)
     */
    async upload(formData) {
      const token = Auth.getToken();
      const response = await fetch(`${BASE_URL}/api/admin/media/upload`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
        },
        body: formData, // FormData는 Content-Type 자동 설정
      });

      if (response.status === 401) {
        Auth.logout();
        window.location.hash = '#/login';
        throw new Error('인증이 만료되었습니다.');
      }

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || '업로드 실패');
      }

      return data;
    },

    /**
     * 미디어 삭제
     *
     * @param {string} type - 파일 타입 (images/audio/video/documents)
     * @param {string} key - 파일 키
     * @returns {Promise<Object>} 성공 메시지
     */
    async delete(type, key) {
      return request(`/api/admin/media/${type}/${key}`, {
        method: 'DELETE',
      });
    },

    /**
     * 미디어 메타데이터 조회
     *
     * @param {string} key - 파일 키
     * @returns {Promise<Object>} 파일 메타데이터 (크기, 타입, 생성일 등)
     */
    async getMetadata(key) {
      return request(`/api/admin/media/metadata/${key}`);
    },
  };

  // =============================================================================
  // Analytics API
  // =============================================================================

  const analyticsAPI = {
    /**
     * 대시보드 개요 통계
     *
     * @param {Object} params - 쿼리 파라미터
     * @param {string} params.period - 기간 (7d/30d/90d)
     * @returns {Promise<Object>} 대시보드 통계 데이터
     */
    async getOverview(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/analytics/overview${queryString}`);
    },

    /**
     * 사용자 분석
     *
     * @param {Object} params - 쿼리 파라미터
     * @returns {Promise<Object>} 사용자 증가, 활동 등 분석 데이터
     */
    async getUserAnalytics(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/analytics/users${queryString}`);
    },

    /**
     * 참여도 지표
     *
     * @param {Object} params - 쿼리 파라미터
     * @returns {Promise<Object>} 완료율, 학습 시간 등 참여도 데이터
     */
    async getEngagement(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/analytics/engagement${queryString}`);
    },

    /**
     * 콘텐츠 통계
     *
     * @returns {Promise<Object>} 레슨, 단어 등 콘텐츠 통계
     */
    async getContentStats() {
      return request('/api/admin/analytics/content');
    },
  };

  // =============================================================================
  // System API
  // =============================================================================

  const systemAPI = {
    /**
     * 시스템 헬스 체크
     *
     * @returns {Promise<Object>} 각 서비스의 상태 (PostgreSQL, MongoDB, Redis, MinIO)
     */
    async getHealth() {
      return request('/api/admin/system/health');
    },

    /**
     * 감사 로그 조회
     *
     * @param {Object} params - 쿼리 파라미터
     * @param {number} params.page - 페이지 번호
     * @param {number} params.limit - 페이지당 항목 수
     * @param {string} params.action - 작업 필터
     * @returns {Promise<{data: Array, pagination: Object}>} 감사 로그 목록
     */
    async getLogs(params = {}) {
      const queryString = buildQueryString(params);
      return request(`/api/admin/system/logs${queryString}`);
    },

    /**
     * 시스템 메트릭 조회
     *
     * @returns {Promise<Object>} 메모리, CPU, 가동 시간 등 시스템 메트릭
     */
    async getMetrics() {
      return request('/api/admin/system/metrics');
    },
  };


  // =============================================================================
  // Docs API
  // =============================================================================

  const docsAPI = {
    /**
     * 문서 목록 조회
     *
     * @returns {Promise<{data: Array}>} 문서 트리 구조
     */
    async list() {
      return request('/api/admin/docs');
    },

    /**
     * 문서 내용 조회
     *
     * @param {string} docPath - 문서 경로
     * @returns {Promise<{data: {path: string, content: string, size: number, modifiedAt: string}}>}
     */
    async content(docPath) {
      const queryString = buildQueryString({ path: docPath });
      return request(`/api/admin/docs/content${queryString}`);
    },
  };

  // =============================================================================
  // Dev Notes API
  // =============================================================================

  const devNotesAPI = {
    /**
     * 개발노트 목록 조회
     *
     * @returns {Promise<{success: boolean, notes: Array, count: number}>} 개발노트 목록
     */
    async list() {
      return request('/api/admin/dev-notes');
    },

    /**
     * 개발노트 내용 조회
     *
     * @param {string} notePath - 노트 경로 (예: 'dev-notes/2026-01-30-example.md')
     * @returns {Promise<{success: boolean, note: Object}>} 노트 내용 및 메타데이터
     */
    async content(notePath) {
      const queryString = buildQueryString({ path: notePath });
      return request(`/api/admin/dev-notes/content${queryString}`);
    },

    /**
     * 카테고리 목록 조회
     *
     * @returns {Promise<{success: boolean, categories: Array}>} 고유 카테고리 목록
     */
    async categories() {
      return request('/api/admin/dev-notes/categories');
    },
  };

  // Public API 반환
  return {
    auth: authAPI,
    users: usersAPI,
    lessons: lessonsAPI,
    vocabulary: vocabularyAPI,
    media: mediaAPI,
    analytics: analyticsAPI,
    system: systemAPI,
    docs: docsAPI,
    devNotes: devNotesAPI,
  };
})();
