-- Migration: Add APK build tracking
-- Date: 2026-02-05
-- Description: APK 빌드 이력 및 실시간 로그 추적

-- Create apk_builds table
CREATE TABLE IF NOT EXISTS apk_builds (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER NOT NULL REFERENCES users(id),
    admin_email VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'building', 'signing', 'completed', 'failed', 'cancelled')),
    progress INTEGER DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
    version_name VARCHAR(20),
    version_code INTEGER,
    apk_size_bytes BIGINT,
    apk_path TEXT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    error_message TEXT,
    git_commit_hash VARCHAR(40),
    git_branch VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create apk_build_logs table
CREATE TABLE IF NOT EXISTS apk_build_logs (
    id SERIAL PRIMARY KEY,
    build_id INTEGER NOT NULL REFERENCES apk_builds(id) ON DELETE CASCADE,
    log_type VARCHAR(20) DEFAULT 'info'
        CHECK (log_type IN ('info', 'error', 'warning')),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_apk_builds_admin_id ON apk_builds(admin_id);
CREATE INDEX IF NOT EXISTS idx_apk_builds_status ON apk_builds(status);
CREATE INDEX IF NOT EXISTS idx_apk_builds_started_at ON apk_builds(started_at DESC);
CREATE INDEX IF NOT EXISTS idx_apk_build_logs_build_id ON apk_build_logs(build_id, created_at);

-- Add comments
COMMENT ON TABLE apk_builds IS 'APK 빌드 이력 및 상태';
COMMENT ON TABLE apk_build_logs IS 'APK 빌드 실시간 로그';

COMMENT ON COLUMN apk_builds.status IS '빌드 상태: pending, building, signing, completed, failed, cancelled';
COMMENT ON COLUMN apk_builds.progress IS '진행률 (0-100)';
COMMENT ON COLUMN apk_builds.duration_seconds IS '빌드 소요 시간 (초)';
COMMENT ON COLUMN apk_builds.apk_size_bytes IS 'APK 파일 크기 (바이트)';
COMMENT ON COLUMN apk_build_logs.log_type IS '로그 타입: info, error, warning';
