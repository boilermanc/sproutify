-- Fix trial for existing user carson05@yopmail.com
-- This user was created BEFORE the migration, so the trigger didn't run

-- First, let's check current state
SELECT
    id,
    email,
    trial_started_at,
    trial_ends_at,
    trial_status,
    trial_banner_dismissed_at
FROM profiles
WHERE email = 'carson05@yopmail.com';

-- Now let's manually initialize the trial (if not already set)
-- This mimics what the trigger would have done
UPDATE profiles
SET
    trial_started_at = COALESCE(trial_started_at, NOW()),
    trial_ends_at = COALESCE(trial_ends_at, NOW() + INTERVAL '7 days'),
    trial_status = COALESCE(trial_status, 'active'),
    trial_banner_dismissed_at = NULL
WHERE email = 'carson05@yopmail.com'
  AND (trial_started_at IS NULL OR trial_ends_at IS NULL OR trial_status IS NULL);

-- Verify the fix
SELECT
    id,
    email,
    trial_started_at,
    trial_ends_at,
    trial_status,
    trial_banner_dismissed_at,
    (trial_ends_at - NOW()) as time_remaining
FROM profiles
WHERE email = 'carson05@yopmail.com';

-- Test the function
SELECT * FROM check_and_update_trial_status(
    (SELECT id FROM profiles WHERE email = 'carson05@yopmail.com')
);
