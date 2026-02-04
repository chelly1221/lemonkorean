-- Migration: Remove design settings table
-- Date: 2026-02-05
-- Description: Complete removal of admin dashboard design customization
-- The App Theme feature for Flutter app customization remains intact

BEGIN;

-- Drop design_settings table if it exists
DROP TABLE IF EXISTS design_settings CASCADE;

-- Optional: Clean up audit logs for design_settings (uncomment if needed)
-- DELETE FROM audit_logs WHERE table_name = 'design_settings';

COMMIT;

-- Note: MinIO design/ folder (logos, favicons) can be cleaned manually if needed
-- This has negligible storage impact and is optional
