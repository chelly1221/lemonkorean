-- 스토리지 리셋 플래그 테이블
-- 관리자가 웹 앱의 localStorage를 원격으로 리셋할 수 있는 기능

CREATE TABLE IF NOT EXISTS storage_reset_flags (
  id SERIAL PRIMARY KEY,

  -- 대상: null = 전체 사용자, user_id = 특정 사용자
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,

  -- 리셋을 요청한 관리자
  admin_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- 리셋 사유 (선택)
  reason TEXT,

  -- 상태: pending, completed, expired
  status VARCHAR(20) NOT NULL DEFAULT 'pending',

  -- 타임스탬프
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP,
  expires_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP + INTERVAL '24 hours',

  -- 감사 로그
  executed_at TIMESTAMP,
  executed_from_ip VARCHAR(45),

  CONSTRAINT valid_status CHECK (status IN ('pending', 'completed', 'expired'))
);

-- 빠른 조회를 위한 인덱스
CREATE INDEX idx_storage_reset_flags_user_status
  ON storage_reset_flags(user_id, status);

CREATE INDEX idx_storage_reset_flags_status_expires
  ON storage_reset_flags(status, expires_at);

COMMENT ON TABLE storage_reset_flags IS '웹 앱 localStorage 원격 리셋 플래그';
COMMENT ON COLUMN storage_reset_flags.user_id IS 'NULL이면 전체 사용자 대상';
COMMENT ON COLUMN storage_reset_flags.admin_id IS '리셋을 요청한 관리자 ID';
COMMENT ON COLUMN storage_reset_flags.status IS 'pending: 대기중, completed: 완료, expired: 만료';
COMMENT ON COLUMN storage_reset_flags.executed_from_ip IS '리셋이 실행된 사용자의 IP 주소 (감사용)';
