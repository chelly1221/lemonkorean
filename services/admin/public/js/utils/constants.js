/**
 * Application Constants
 *
 * 앱 전역에서 사용되는 상수 정의
 */

const Constants = {
  // 페이지네이션
  PAGINATION: {
    DEFAULT_PAGE: 1,
    DEFAULT_LIMIT: 10,
    LIMITS: [10, 20, 50, 100],
  },

  // 레슨 상태
  LESSON_STATUS: {
    DRAFT: 'draft',
    PUBLISHED: 'published',
    ARCHIVED: 'archived',
  },

  LESSON_STATUS_LABELS: {
    draft: '초안',
    published: '발행됨',
    archived: '보관됨',
  },

  LESSON_STATUS_COLORS: {
    draft: 'secondary',
    published: 'success',
    archived: 'warning',
  },

  // 레슨 레벨
  LESSON_LEVELS: [1, 2, 3, 4, 5, 6],

  // 레슨 난이도
  LESSON_DIFFICULTY: {
    BEGINNER: 'beginner',
    ELEMENTARY: 'elementary',
    INTERMEDIATE: 'intermediate',
    ADVANCED: 'advanced',
  },

  LESSON_DIFFICULTY_LABELS: {
    beginner: '입문',
    elementary: '초급',
    intermediate: '중급',
    advanced: '고급',
  },

  // 구독 타입
  SUBSCRIPTION_TYPES: {
    FREE: 'free',
    PREMIUM: 'premium',
  },

  SUBSCRIPTION_LABELS: {
    free: '무료',
    premium: '프리미엄',
  },

  SUBSCRIPTION_COLORS: {
    free: 'secondary',
    premium: 'warning',
  },

  // 사용자 상태
  USER_STATUS: {
    ACTIVE: 'active',
    INACTIVE: 'inactive',
    BANNED: 'banned',
  },

  USER_STATUS_LABELS: {
    active: '활성',
    inactive: '비활성',
    banned: '차단됨',
  },

  USER_STATUS_COLORS: {
    active: 'success',
    inactive: 'secondary',
    banned: 'danger',
  },

  // 미디어 파일 타입
  MEDIA_TYPES: {
    IMAGES: 'images',
    AUDIO: 'audio',
    VIDEO: 'video',
    DOCUMENTS: 'documents',
  },

  MEDIA_TYPE_LABELS: {
    images: '이미지',
    audio: '오디오',
    video: '비디오',
    documents: '문서',
  },

  // 파일 크기 제한 (바이트)
  FILE_SIZE_LIMITS: {
    images: 10 * 1024 * 1024,    // 10MB
    audio: 50 * 1024 * 1024,     // 50MB
    video: 200 * 1024 * 1024,    // 200MB
    documents: 20 * 1024 * 1024, // 20MB
  },

  // 허용된 파일 확장자
  ALLOWED_EXTENSIONS: {
    images: ['.jpg', '.jpeg', '.png', '.gif', '.webp'],
    audio: ['.mp3', '.wav', '.ogg', '.m4a'],
    video: ['.mp4', '.webm', '.mov'],
    documents: ['.pdf', '.doc', '.docx', '.txt'],
  },

  // 대시보드 기간
  DASHBOARD_PERIODS: {
    WEEK: '7d',
    MONTH: '30d',
    QUARTER: '90d',
  },

  DASHBOARD_PERIOD_LABELS: {
    '7d': '최근 7일',
    '30d': '최근 30일',
    '90d': '최근 90일',
  },

  // 날짜 포맷
  DATE_FORMATS: {
    FULL: 'YYYY-MM-DD HH:mm:ss',
    DATE: 'YYYY-MM-DD',
    TIME: 'HH:mm:ss',
    DATETIME: 'YYYY-MM-DD HH:mm',
  },

  // Toast 알림 타입
  TOAST_TYPES: {
    SUCCESS: 'success',
    ERROR: 'danger',
    WARNING: 'warning',
    INFO: 'info',
  },

  // 감사 로그 작업
  AUDIT_ACTIONS: {
    CREATE: 'create',
    UPDATE: 'update',
    DELETE: 'delete',
    PUBLISH: 'publish',
    UNPUBLISH: 'unpublish',
    BAN: 'ban',
    UNBAN: 'unban',
  },

  AUDIT_ACTION_LABELS: {
    create: '생성',
    update: '수정',
    delete: '삭제',
    publish: '발행',
    unpublish: '미발행',
    ban: '차단',
    unban: '차단 해제',
  },

  // 품사 (Part of Speech)
  PARTS_OF_SPEECH: {
    NOUN: 'noun',
    VERB: 'verb',
    ADJECTIVE: 'adjective',
    ADVERB: 'adverb',
    PARTICLE: 'particle',
    PRONOUN: 'pronoun',
    NUMERAL: 'numeral',
    INTERJECTION: 'interjection',
  },

  PARTS_OF_SPEECH_LABELS: {
    noun: '명사',
    verb: '동사',
    adjective: '형용사',
    adverb: '부사',
    particle: '조사',
    pronoun: '대명사',
    numeral: '수사',
    interjection: '감탄사',
  },

  // 차트 색상
  CHART_COLORS: {
    PRIMARY: '#0d6efd',
    SUCCESS: '#198754',
    DANGER: '#dc3545',
    WARNING: '#ffc107',
    INFO: '#0dcaf0',
    SECONDARY: '#6c757d',
  },

  // 로딩 메시지
  LOADING_MESSAGES: {
    DEFAULT: '로딩 중...',
    SAVING: '저장 중...',
    DELETING: '삭제 중...',
    UPLOADING: '업로드 중...',
    PROCESSING: '처리 중...',
  },
};
