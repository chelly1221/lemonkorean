-- Migration: Add web deployment tracking
-- Date: 2026-02-04
-- Description: 웹 앱 배포 이력 및 실시간 로그 추적

-- Create web_deployments table
CREATE TABLE IF NOT EXISTS web_deployments (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER NOT NULL REFERENCES users(id),
    admin_email VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'building', 'syncing', 'restarting',
                          'validating', 'completed', 'failed', 'cancelled')),
    progress INTEGER DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    error_message TEXT,
    git_commit_hash VARCHAR(40),
    git_branch VARCHAR(100),
    deployment_url TEXT DEFAULT 'https://lemon.3chan.kr/app/',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create web_deployment_logs table
CREATE TABLE IF NOT EXISTS web_deployment_logs (
    id SERIAL PRIMARY KEY,
    deployment_id INTEGER NOT NULL REFERENCES web_deployments(id) ON DELETE CASCADE,
    log_type VARCHAR(20) DEFAULT 'info'
        CHECK (log_type IN ('info', 'error', 'warning')),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_web_deployments_admin_id ON web_deployments(admin_id);
CREATE INDEX IF NOT EXISTS idx_web_deployments_status ON web_deployments(status);
CREATE INDEX IF NOT EXISTS idx_web_deployments_started_at ON web_deployments(started_at DESC);
CREATE INDEX IF NOT EXISTS idx_deployment_logs_deployment_id ON web_deployment_logs(deployment_id, created_at);

-- Add comments
COMMENT ON TABLE web_deployments IS '웹 앱 배포 이력 및 상태';
COMMENT ON TABLE web_deployment_logs IS '배포 실시간 로그';

COMMENT ON COLUMN web_deployments.status IS '배포 상태: pending, building, syncing, restarting, validating, completed, failed, cancelled';
COMMENT ON COLUMN web_deployments.progress IS '진행률 (0-100)';
COMMENT ON COLUMN web_deployments.duration_seconds IS '배포 소요 시간 (초)';
COMMENT ON COLUMN web_deployment_logs.log_type IS '로그 타입: info, error, warning';
