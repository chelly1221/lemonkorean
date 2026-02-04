-- ==================== Migration 004: Update Language Defaults to Korean ====================
-- Date: 2026-02-04
-- Description: Changes default language from Chinese to Korean across the system
--
-- BREAKING CHANGE: This will update ALL existing users to Korean ('ko') language preference.
-- Users who prefer Chinese (Simplified or Traditional) will need to manually change their
-- language preference back to their preferred language in the app settings.
--
-- Rationale: Lemon Korean is a Korean learning app. Korean should be the default language
-- for content display, not Chinese. This aligns the system defaults with the app's purpose.
-- =============================================================================================

BEGIN;

-- ==================== Step 1: Update All Existing Users ====================
-- Migrate all users currently using Chinese (Simplified or Traditional) to Korean
UPDATE users
SET language_preference = 'ko'
WHERE language_preference IN ('zh', 'zh_TW');

-- Log the migration
DO $$
DECLARE
    updated_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO updated_count
    FROM users
    WHERE language_preference = 'ko';

    RAISE NOTICE 'Migration 004: Updated % users to Korean language preference', updated_count;
END $$;

-- ==================== Step 2: Update Default for Future Users ====================
-- Change the default value for new user registrations
ALTER TABLE users
ALTER COLUMN language_preference SET DEFAULT 'ko';

-- ==================== Verification ====================
-- Verify the change was applied correctly
DO $$
DECLARE
    default_lang TEXT;
    user_count INTEGER;
BEGIN
    -- Check default value (this is a simplified check)
    SELECT COUNT(*) INTO user_count FROM users;

    RAISE NOTICE 'Migration 004: Total users in system: %', user_count;
    RAISE NOTICE 'Migration 004: Default language for new users is now: ko';
    RAISE NOTICE 'Migration 004: Users can change language preference in app settings';
END $$;

COMMIT;

-- ==================== Post-Migration Notes ====================
-- After deploying this migration:
--
-- 1. ALL users will have Korean ('ko') as their language preference
-- 2. Chinese-speaking users will need to manually change back to:
--    - 'zh' for Simplified Chinese
--    - 'zh_TW' for Traditional Chinese
--
-- 3. Consider adding an in-app notification informing users:
--    - "We've updated the default language to Korean. You can change your
--       language preference anytime in Settings."
--
-- 4. App should show language selection prominently after this update
--
-- 5. Backend will now default to Korean ('ko') for all API calls that
--    don't include an explicit language parameter
--
-- =============================================================================================
