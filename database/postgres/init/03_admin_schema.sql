-- ==================== Admin Service Database Schema ====================
-- This script adds tables and columns needed for the Admin Dashboard service
-- Run after 01_schema.sql and 02_seed.sql
-- ========================================================================

-- 1. Add role column to users table for role-based access control
ALTER TABLE users ADD COLUMN IF NOT EXISTS role VARCHAR(20) DEFAULT 'user'
  CHECK (role IN ('user', 'admin', 'content_editor', 'super_admin'));

CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

COMMENT ON COLUMN users.role IS 'User role: user (default), admin, content_editor, super_admin';

-- 2. Create admin audit logs table for compliance and debugging
CREATE TABLE IF NOT EXISTS admin_audit_logs (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER NOT NULL REFERENCES users(id) ON DELETE SET NULL,
    admin_email VARCHAR(255) NOT NULL,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    resource_id INTEGER,
    changes JSONB,
    ip_address INET,
    user_agent TEXT,
    status VARCHAR(20) DEFAULT 'success' CHECK (status IN ('success', 'failed', 'pending')),
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_admin_audit_admin ON admin_audit_logs(admin_id);
CREATE INDEX IF NOT EXISTS idx_admin_audit_action ON admin_audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_admin_audit_resource ON admin_audit_logs(resource_type, resource_id);
CREATE INDEX IF NOT EXISTS idx_admin_audit_created ON admin_audit_logs(created_at DESC);

COMMENT ON TABLE admin_audit_logs IS 'Audit trail for all admin actions';
COMMENT ON COLUMN admin_audit_logs.action IS 'Action performed: create_lesson, update_user, ban_user, etc.';
COMMENT ON COLUMN admin_audit_logs.resource_type IS 'Type of resource: lesson, user, vocabulary, etc.';
COMMENT ON COLUMN admin_audit_logs.changes IS 'JSON object containing the changes made';

-- 3. Create system stats cache table for dashboard performance
CREATE TABLE IF NOT EXISTS system_stats_cache (
    id SERIAL PRIMARY KEY,
    stat_key VARCHAR(100) UNIQUE NOT NULL,
    stat_value JSONB NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_system_stats_key ON system_stats_cache(stat_key);
CREATE INDEX IF NOT EXISTS idx_system_stats_expires ON system_stats_cache(expires_at);

COMMENT ON TABLE system_stats_cache IS 'Cached system statistics for admin dashboard (reduces query load)';
COMMENT ON COLUMN system_stats_cache.stat_key IS 'Unique key for the statistic (e.g., "users_total", "lessons_published")';
COMMENT ON COLUMN system_stats_cache.stat_value IS 'JSON value of the statistic';
COMMENT ON COLUMN system_stats_cache.expires_at IS 'Cache expiration timestamp';

-- 4. Update existing admin user to have super_admin role
UPDATE users SET role = 'super_admin'
WHERE email IN ('admin@lemon.com', 'admin@lemonkorean.com')
AND role != 'super_admin';

-- 5. Create a function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 6. Create trigger for system_stats_cache
CREATE TRIGGER trigger_update_system_stats_cache_updated_at
    BEFORE UPDATE ON system_stats_cache
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Verification queries (run these to verify schema was applied)
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name='users' AND column_name='role';
-- SELECT COUNT(*) FROM admin_audit_logs;
-- SELECT COUNT(*) FROM system_stats_cache;
